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
)

type saavnAuthResponse struct {
	AuthURL string `json:"auth_url"`
	Status  string `json:"status"`
}

func fetchSaavnAuthURL(ctx context.Context, client *http.Client, encURL string) (string, error) {
	tokenURL := fmt.Sprintf(
		"https://www.jiosaavn.com/api.php?__call=song.generateAuthToken&url=%s&bit_rate=320&api_version=4&_format=json&ctx=web6dot0&_marker=0",
		url.QueryEscape(encURL),
	)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, tokenURL, nil)
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

	var aResp saavnAuthResponse
	if err := json.Unmarshal(body, &aResp); err != nil || aResp.Status != "success" || aResp.AuthURL == "" {
		return "", errors.New("invalid auth token response")
	}

	if isValidSaavnStream(ctx, client, aResp.AuthURL) {
		return aResp.AuthURL, nil
	}
	return "", errors.New("stream url validation failed")
}

func isValidSaavnStream(ctx context.Context, client *http.Client, streamURL string) bool {
	chkReq, err := http.NewRequestWithContext(ctx, http.MethodHead, streamURL, nil)
	if err != nil {
		return false
	}
	chkReq.Header.Set("Referer", "https://www.jiosaavn.com/")
	chkReq.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

	chkResp, err := client.Do(chkReq)
	if err != nil {
		return false
	}
	defer chkResp.Body.Close()
	return (chkResp.StatusCode == http.StatusOK || chkResp.StatusCode == http.StatusPartialContent) && strings.Contains(chkResp.Header.Get("Content-Type"), "audio")
}
