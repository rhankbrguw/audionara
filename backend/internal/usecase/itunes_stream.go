package usecase

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"
)

type itunesSearchResult struct {
	ResultCount int `json:"resultCount"`
	Results     []struct {
		PreviewURL string `json:"previewUrl"`
		ArtistName string `json:"artistName"`
		TrackName  string `json:"trackName"`
	} `json:"results"`
}

func resolveAudioStreamViaITunes(ctx context.Context, artist, title string) (string, error) {
	cleanArtist := strings.TrimSpace(artist)
	cleanTitle := strings.TrimSpace(title)
	if cleanArtist == "" && cleanTitle == "" {
		return "", errors.New("empty search term")
	}

	client := &http.Client{Timeout: 4 * time.Second}
	queries := []string{
		url.QueryEscape(cleanTitle),
		url.QueryEscape(fmt.Sprintf("%s %s", cleanTitle, cleanArtist)),
	}

	for _, q := range queries {
		if streamURL, err := queryITunesSong(ctx, client, q, cleanArtist); err == nil && streamURL != "" {
			return streamURL, nil
		}
	}
	return "", errors.New("no itunes stream available")
}

func queryITunesSong(ctx context.Context, client *http.Client, term, artist string) (string, error) {
	reqURL := fmt.Sprintf("https://itunes.apple.com/search?term=%s&entity=song&limit=10", term)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, reqURL, nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("itunes status: %d", resp.StatusCode)
	}

	var res itunesSearchResult
	if err := json.NewDecoder(resp.Body).Decode(&res); err != nil {
		return "", err
	}

	lowerArtist := strings.ToLower(artist)
	for _, item := range res.Results {
		if item.PreviewURL == "" {
			continue
		}
		if lowerArtist == "" || strings.Contains(strings.ToLower(item.ArtistName), lowerArtist) {
			return item.PreviewURL, nil
		}
	}
	if len(res.Results) > 0 && res.Results[0].PreviewURL != "" {
		return res.Results[0].PreviewURL, nil
	}
	return "", errors.New("not found")
}
