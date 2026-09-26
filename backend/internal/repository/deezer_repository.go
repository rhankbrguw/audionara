package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

// DeezerRepository implements domain.TrackRepository using Deezer API & Wikipedia.
type DeezerRepository struct {
	client      *http.Client
	cache       sync.Map
	cacheRepo   CacheRepository
	baseURL     string
	wikiBaseURL string
}

// NewDeezerRepository constructs a high-performance DeezerRepository.
func NewDeezerRepository(cacheRepo CacheRepository) *DeezerRepository {
	return &DeezerRepository{
		client: &http.Client{
			Timeout: 10 * time.Second,
			Transport: &http.Transport{
				MaxIdleConns:        100,
				MaxIdleConnsPerHost: 20,
				IdleConnTimeout:     90 * time.Second,
			},
		},
		cacheRepo:   cacheRepo,
		baseURL:     "https://api.deezer.com",
		wikiBaseURL: "https://en.wikipedia.org/api/rest_v1",
	}
}

func (r *DeezerRepository) fetchJSON(ctx context.Context, endpoint string, target any) error {
	fullURL := r.baseURL + endpoint
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, fullURL, nil)
	if err != nil {
		return fmt.Errorf("deezer request: %w", err)
	}
	req.Header.Set("User-Agent", "AudioNara/1.0")

	resp, err := r.client.Do(req)
	if err != nil {
		return fmt.Errorf("deezer do: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("deezer status: %d", resp.StatusCode)
	}
	return json.NewDecoder(resp.Body).Decode(target)
}

func (r *DeezerRepository) fetchWikiSummary(ctx context.Context, artistName string) (string, string) {
	candidates := []string{
		artistName,
		artistName + " (band)",
		artistName + " (musician)",
		artistName + " (singer)",
		artistName + " (rapper)",
	}

	for _, cand := range candidates {
		extract, desc := r.fetchSingleWikiSummary(ctx, cand)
		if extract != "" && (isMusicWiki(desc) || isMusicWiki(extract)) {
			return extract, desc
		}
	}
	return r.fetchSingleWikiSummary(ctx, artistName)
}

func (r *DeezerRepository) fetchSingleWikiSummary(ctx context.Context, title string) (string, string) {
	escaped := url.PathEscape(title)
	fullURL := fmt.Sprintf("%s/page/summary/%s", r.wikiBaseURL, escaped)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, fullURL, nil)
	if err != nil {
		return "", ""
	}
	req.Header.Set("User-Agent", "AudioNara/1.0 (contact: info@audionara.app)")

	resp, err := r.client.Do(req)
	if err != nil || resp.StatusCode != http.StatusOK {
		return "", ""
	}
	defer resp.Body.Close()

	var wiki struct {
		Description string `json:"description"`
		Extract     string `json:"extract"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&wiki); err != nil {
		return "", ""
	}
	return wiki.Extract, wiki.Description
}

func isMusicWiki(text string) bool {
	lower := strings.ToLower(text)
	keywords := []string{"band", "singer", "musician", "music", "rock", "pop", "album", "song", "rapper", "artist", "group"}
	for _, kw := range keywords {
		if strings.Contains(lower, kw) {
			return true
		}
	}
	return false
}

// FindByID retrieves a single track by its Deezer ID.
func (r *DeezerRepository) FindByID(ctx context.Context, id string) (*domain.Track, error) {
	if id == "" {
		return nil, domain.ErrNotSupported
	}
	var dto deezerTrackDTO
	if err := r.fetchJSON(ctx, "/track/"+id, &dto); err != nil {
		return nil, err
	}
	return mapDeezerTrackToDomain(dto), nil
}

// FindAll is not supported for external dynamic catalogue.
func (r *DeezerRepository) FindAll(ctx context.Context) ([]*domain.Track, error) {
	return nil, domain.ErrNotSupported
}

// Save is not supported for external read-only catalog.
func (r *DeezerRepository) Save(ctx context.Context, track *domain.Track) error {
	return domain.ErrNotSupported
}

// Delete is not supported for external read-only catalog.
func (r *DeezerRepository) Delete(ctx context.Context, id string) error {
	return domain.ErrNotSupported
}
