package usecase

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"time"
)

func resolveAudioStreamViaDeezer(ctx context.Context, artist, title string) (string, error) {
	client := &http.Client{Timeout: 5 * time.Second}
	q := url.QueryEscape(fmt.Sprintf("%s %s", artist, title))
	reqURL := fmt.Sprintf("https://api.deezer.com/search?q=%s&limit=1", q)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, reqURL, nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var payload struct {
		Data []struct {
			Preview string `json:"preview"`
		} `json:"data"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return "", err
	}
	if len(payload.Data) == 0 || payload.Data[0].Preview == "" {
		return "", errors.New("no stream available from audio provider")
	}
	return payload.Data[0].Preview, nil
}
