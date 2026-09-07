package usecase

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

// GetAlbumDetail retrieves the AlbumDetail based on the provided parameters.
func (uc *TrackUseCase) GetAlbumDetail(ctx context.Context, albumID string, explicit bool, quality int) (*domain.AlbumDetail, error) {
	if albumID == "" {
		return nil, fmt.Errorf("album id must not be empty")
	}
	detail, err := uc.repo.GetAlbumDetail(ctx, albumID)
	if err == nil {
		detail.Tracks = overrideURLs(detail.Tracks)
		uc.PreFetchStreamURLs(detail.Tracks, 2, explicit, quality)
	}
	return detail, err
}

// GetArtistTopSongs retrieves the top songs for an artist.
func (uc *TrackUseCase) GetArtistTopSongs(ctx context.Context, artistID string, explicit bool, quality int) ([]*domain.Track, error) {
	if artistID == "" {
		return nil, fmt.Errorf("artist id must not be empty")
	}
	tracks, err := uc.repo.GetArtistTopSongs(ctx, artistID, explicit)
	if err == nil {
		tracks = overrideURLs(tracks)
		uc.PreFetchStreamURLs(tracks, 2, explicit, quality)
	}
	return tracks, err
}

// GetArtistDetail retrieves rich artist details including bio, history, top songs, and albums.
func (uc *TrackUseCase) GetArtistDetail(ctx context.Context, artistID string, explicit bool, quality int) (*domain.ArtistDetail, error) {
	if artistID == "" {
		return nil, fmt.Errorf("artist id must not be empty")
	}
	detail, err := uc.repo.GetArtistDetail(ctx, artistID)
	if err == nil && detail != nil {
		detail.TopTracks = overrideURLs(detail.TopTracks)
		uc.PreFetchStreamURLs(detail.TopTracks, 2, explicit, quality)
	}
	return detail, err
}

// GetLyrics fetches lyrics from lrclib.net with fallback search, caching in Redis.
func (uc *TrackUseCase) GetLyrics(ctx context.Context, artist, title, duration string) (string, error) {
	cArtist, cTitle := cleanLyricsQuery(artist, title)
	cacheKey := fmt.Sprintf("%s:%s:%s", cArtist, cTitle, duration)
	if cached, err := uc.cacheRepo.GetLyrics(ctx, cArtist, cacheKey); err == nil {
		if cached == "NOT_FOUND" {
			return "", errors.New("lyrics not found")
		}
		return cached, nil
	}
	rawJson, err := uc.fetchLyricsFromLrclib(ctx, cArtist, cTitle, duration)
	if err != nil {
		_ = uc.cacheRepo.SetLyrics(ctx, cArtist, cacheKey, "NOT_FOUND", 1*time.Hour)
		return "", errors.New("lyrics not found")
	}
	_ = uc.cacheRepo.SetLyrics(ctx, cArtist, cacheKey, rawJson, 72*time.Hour)
	return rawJson, nil
}

func cleanLyricsQuery(artist, title string) (string, string) {
	cArtist := strings.TrimSpace(strings.TrimSuffix(strings.TrimSpace(artist), " - Topic"))
	cTitle := strings.TrimSpace(title)
	for _, sep := range []string{" [", " (", " - ", " feat.", " ft.", " Feat."} {
		if idx := strings.Index(cTitle, sep); idx != -1 {
			cTitle = cTitle[:idx]
		}
	}
	return cArtist, strings.TrimRight(strings.TrimSpace(cTitle), ".!? ")
}

func (uc *TrackUseCase) fetchLyricsFromLrclib(ctx context.Context, artist, title, duration string) (string, error) {
	var fallbackPlain string
	durParam := ""
	if duration != "" && duration != "0" {
		durParam = "&duration=" + url.QueryEscape(duration)
	}
	getURL := fmt.Sprintf("https://lrclib.net/api/get?artist_name=%s&track_name=%s%s", url.QueryEscape(artist), url.QueryEscape(title), durParam)
	body, code, err := uc.execLrclibReq(ctx, getURL)
	if err == nil && code == http.StatusOK {
		var res map[string]interface{}
		if json.Unmarshal(body, &res) == nil {
			if s, ok := res["syncedLyrics"].(string); ok && strings.TrimSpace(s) != "" {
				return string(body), nil
			}
			if p, ok := res["plainLyrics"].(string); ok && strings.TrimSpace(p) != "" {
				fallbackPlain = string(body)
			}
		}
	}
	for _, q := range []string{artist + " " + title, title} {
		searchURL := fmt.Sprintf("https://lrclib.net/api/search?q=%s", url.QueryEscape(q))
		body, code, err = uc.execLrclibReq(ctx, searchURL)
		if err == nil && code == http.StatusOK {
			var list []map[string]interface{}
			if json.Unmarshal(body, &list) == nil {
				for _, item := range list {
					if s, ok := item["syncedLyrics"].(string); ok && strings.TrimSpace(s) != "" {
						b, _ := json.Marshal(item)
						return string(b), nil
					}
				}
				if fallbackPlain == "" && len(list) > 0 {
					b, _ := json.Marshal(list[0])
					fallbackPlain = string(b)
				}
			}
		}
	}
	if fallbackPlain != "" {
		return fallbackPlain, nil
	}
	return "", errors.New("not found")
}

func (uc *TrackUseCase) execLrclibReq(ctx context.Context, targetURL string) ([]byte, int, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, targetURL, nil)
	if err != nil {
		return nil, 0, err
	}
	req.Header.Set("User-Agent", "Audionara/1.0.0 (https://github.com/user/audionara)")
	client := &http.Client{Timeout: 10 * time.Second, Transport: &http.Transport{
		ForceAttemptHTTP2: false,
		TLSNextProto:      make(map[string]func(string, *tls.Conn) http.RoundTripper),
	}}
	resp, err := client.Do(req)
	if err != nil {
		return nil, 0, err
	}
	defer resp.Body.Close()
	body, err := io.ReadAll(resp.Body)
	return body, resp.StatusCode, err
}
