package usecase

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

type saavnSearchResponse struct {
	Results []struct {
		Title    string `json:"title"`
		Subtitle string `json:"subtitle"`
		MoreInfo struct {
			EncryptedMediaURL string `json:"encrypted_media_url"`
			Duration          string `json:"duration"`
		} `json:"more_info"`
	} `json:"results"`
}

func resolveStudioSaavnAudio(ctx context.Context, artist, title string) (string, error) {
	if strings.TrimSpace(artist) == "" || strings.TrimSpace(title) == "" {
		return "", errors.New("empty artist or title")
	}
	client := &http.Client{Timeout: 5 * time.Second}
	queries := []string{
		fmt.Sprintf("%s %s", artist, title),
		fmt.Sprintf("%s %s", title, artist),
	}

	for _, q := range queries {
		if streamURL, err := searchSaavnWithQuery(ctx, client, q, artist, title); err == nil && streamURL != "" {
			return streamURL, nil
		}
	}
	return "", errors.New("no stream found on primary audio cdn")
}

func isUnwantedVariant(title, subtitle string) bool {
	lower := strings.ToLower(title + " " + subtitle)
	variants := []string{"karaoke", "instrumental", "ambient", "nightcore", "slowed", "sped up", "tribute", "originally performed", "cover by", "remake"}
	for _, v := range variants {
		if strings.Contains(lower, v) {
			return true
		}
	}
	return false
}

func isMatchingArtist(artist, subtitle, title string) bool {
	cleanArtist := strings.ToLower(strings.TrimSpace(artist))
	if cleanArtist == "" {
		return false
	}
	subLower := strings.ToLower(subtitle)
	titleLower := strings.ToLower(title)
	return strings.Contains(subLower, cleanArtist) || strings.Contains(titleLower, cleanArtist)
}


func searchSaavnWithQuery(ctx context.Context, client *http.Client, query, artist, title string) (string, error) {
	apiURL := fmt.Sprintf(
		"https://www.jiosaavn.com/api.php?__call=search.getResults&_format=json&_marker=0&api_version=4&ctx=web6dot0&n=5&p=1&q=%s",
		url.QueryEscape(query),
	)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, apiURL, nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	var sResp saavnSearchResponse
	if err := json.Unmarshal(body, &sResp); err != nil || len(sResp.Results) == 0 {
		return "", errors.New("empty search results")
	}

	for _, item := range sResp.Results {
		if item.MoreInfo.EncryptedMediaURL == "" {
			continue
		}
		if isUnwantedVariant(item.Title, item.Subtitle) {
			continue
		}
		if !isMatchingArtist(artist, item.Subtitle, item.Title) {
			continue
		}
		if authURL, err := fetchSaavnAuthURL(ctx, client, item.MoreInfo.EncryptedMediaURL); err == nil && authURL != "" {
			return authURL, nil
		}
	}
	return "", errors.New("failed to authorize media stream")
}
