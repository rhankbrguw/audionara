package usecase

import (
	"context"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

func overrideURLs(tracks []*domain.Track) []*domain.Track {
	for _, t := range tracks {
		t.StreamURL = fmt.Sprintf("/api/v1/tracks/stream.m4a?artist=%s&title=%s", url.QueryEscape(t.Artist), url.QueryEscape(t.Title))
	}
	return tracks
}

// GetYouTubeStreamURL fetches direct audio URL with L1/L2 caching and singleflight deduplication.
func (uc *TrackUseCase) GetYouTubeStreamURL(ctx context.Context, artist, title string, explicit bool, quality int) (string, error) {
	cleanTitle := normalizeTrackTitle(title)

	if cached, err := uc.cacheRepo.GetStreamURL(ctx, artist, cleanTitle); err == nil && cached != "" {
		return cached, nil
	}

	flightKey := fmt.Sprintf("%s:%s:%t", artist, cleanTitle, explicit)
	return uc.flight.Do(flightKey, func() (string, error) {
		if cached, err := uc.cacheRepo.GetStreamURL(ctx, artist, cleanTitle); err == nil && cached != "" {
			return cached, nil
		}
		streamURL, isFull := uc.resolveStreamWithFallbacks(ctx, artist, cleanTitle, explicit)
		if streamURL == "" {
			return "", fmt.Errorf("no stream available for %s - %s", artist, cleanTitle)
		}
		ttl := 30 * time.Second
		if isFull {
			ttl = 24 * time.Hour
		}
		_ = uc.cacheRepo.SetStreamURL(ctx, artist, cleanTitle, streamURL, ttl)
		return streamURL, nil
	})
}

func (uc *TrackUseCase) resolveStreamWithFallbacks(ctx context.Context, artist, cleanTitle string, explicit bool) (string, bool) {
	searchTitle := cleanTitle
	if !explicit {
		searchTitle = cleanTitle + " clean"
	}
	if url, err := resolveStudioMasterAudio(ctx, artist, searchTitle); err == nil && url != "" {
		if isValidStreamURL(ctx, url) {
			return url, true
		}
	}
	if url, err := resolveAudioStreamViaInnerTube(ctx, artist, searchTitle); err == nil && url != "" {
		if isValidStreamURL(ctx, url) {
			return url, true
		}
	}
	if url, err := resolveStudioSaavnAudio(ctx, artist, searchTitle); err == nil && url != "" {
		return url, true
	}
	if url, err := resolveAudioStreamViaDeezer(ctx, artist, cleanTitle); err == nil && url != "" {
		return url, false
	}
	return "", false
}

func isValidStreamURL(ctx context.Context, streamURL string) bool {
	checkCtx, cancel := context.WithTimeout(ctx, 3*time.Second)
	defer cancel()
	req, err := http.NewRequestWithContext(checkCtx, http.MethodGet, streamURL, nil)
	if err != nil {
		return false
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
	req.Header.Set("Range", "bytes=0-1024")
	client := &http.Client{Timeout: 3 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return false
	}
	defer resp.Body.Close()
	return resp.StatusCode == http.StatusOK || resp.StatusCode == http.StatusPartialContent
}

func normalizeTrackTitle(title string) string {
	clean := strings.Split(title, " - ")[0]
	clean = strings.Split(clean, " (")[0]
	clean = strings.Split(clean, " [")[0]
	clean = strings.Split(clean, ";")[0]
	return strings.TrimSpace(clean)
}

// PreFetchStreamURLs pre-warms top tracks into cache in background.
func (uc *TrackUseCase) PreFetchStreamURLs(tracks []*domain.Track, limit int, explicit bool, quality int) {
	if len(tracks) == 0 {
		return
	}
	count := limit
	if count <= 0 || count > 3 {
		count = 3
	}
	if count > len(tracks) {
		count = len(tracks)
	}
	toFetch := make([]*domain.Track, count)
	copy(toFetch, tracks[:count])

	go func(items []*domain.Track) {
		bgCtx, cancel := context.WithTimeout(context.Background(), 25*time.Second)
		defer cancel()
		for _, track := range items {
			t := track
			go func() {
				_, _ = uc.GetYouTubeStreamURL(bgCtx, t.Artist, t.Title, explicit, quality)
				_, _ = uc.GetLyrics(bgCtx, t.Artist, t.Title)
			}()
		}
	}(toFetch)
}
