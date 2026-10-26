package usecase

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"
)

type innerTubeSearchReq struct {
	Context map[string]interface{} `json:"context"`
	Query   string                 `json:"query"`
}

type innerTubePlayerReq struct {
	Context map[string]interface{} `json:"context"`
	VideoID string                 `json:"videoId"`
}

func fetchVideoIDFromInnerTube(ctx context.Context, client *http.Client, query string) (string, error) {
	payload := innerTubeSearchReq{
		Context: map[string]interface{}{
			"client": map[string]interface{}{
				"clientName":    "WEB",
				"clientVersion": "2.20240101.00.00",
				"hl":            "en",
				"gl":            "US",
			},
		},
		Query: query,
	}
	bodyBytes, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, "https://www.youtube.com/youtubei/v1/search", bytes.NewReader(bodyBytes))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var data map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
		return "", err
	}
	raw, err := json.Marshal(data)
	if err != nil {
		return "", err
	}
	str := string(raw)
	idx := strings.Index(str, `"videoId":"`)
	if idx == -1 {
		return "", errors.New("video id not found")
	}
	sub := str[idx+len(`"videoId":"`):]
	end := strings.Index(sub, `"`)
	if end == -1 {
		return "", errors.New("malformed video id")
	}
	return sub[:end], nil
}

func fetchAudioURLFromInnerTube(ctx context.Context, client *http.Client, videoID string) (string, error) {
	payload := innerTubePlayerReq{
		Context: map[string]interface{}{
			"client": map[string]interface{}{
				"clientName":    "IOS",
				"clientVersion": "19.29.1",
				"deviceModel":   "iPhone16,2",
				"hl":            "en",
				"gl":            "US",
			},
		},
		VideoID: videoID,
	}
	bodyBytes, err := json.Marshal(payload)
	if err != nil {
		return "", err
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, "https://www.youtube.com/youtubei/v1/player", bytes.NewReader(bodyBytes))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("User-Agent", "com.google.ios.youtube/19.29.1 (iPhone16,2; U; CPU iOS 17_5_1 like Mac OS X; en_US)")

	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	var data map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
		return "", err
	}
	streamingData, ok := data["streamingData"].(map[string]interface{})
	if !ok {
		return "", errors.New("no streaming data in player response")
	}
	formats, ok := streamingData["adaptiveFormats"].([]interface{})
	if !ok {
		return "", errors.New("no adaptive formats in player response")
	}
	for _, f := range formats {
		fmtMap, ok := f.(map[string]interface{})
		if !ok {
			continue
		}
		mime, _ := fmtMap["mimeType"].(string)
		if strings.HasPrefix(mime, "audio/") {
			if u, ok := fmtMap["url"].(string); ok && u != "" {
				return u, nil
			}
		}
	}
	return "", errors.New("no audio stream url found")
}

func resolveAudioStreamViaInnerTube(ctx context.Context, artist, title string) (string, error) {
	client := &http.Client{Timeout: 6 * time.Second}
	query := fmt.Sprintf("%s %s audio", artist, title)
	videoID, err := fetchVideoIDFromInnerTube(ctx, client, query)
	if err != nil {
		return "", fmt.Errorf("innertube search: %w", err)
	}
	audioURL, err := fetchAudioURLFromInnerTube(ctx, client, videoID)
	if err != nil {
		return "", fmt.Errorf("innertube player: %w", err)
	}
	return audioURL, nil
}
