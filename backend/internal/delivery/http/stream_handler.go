package http

import (
	"io"
	"log"
	"net/http"
	"strconv"
	"strings"
)

// getStream proxies the resolved audio stream URL with automatic retry and invalidation.
func (h *Handler) getStream(w http.ResponseWriter, r *http.Request) {
	artist := strings.TrimSpace(r.URL.Query().Get("artist"))
	title := strings.TrimSpace(r.URL.Query().Get("title"))
	if artist == "" || title == "" {
		writeJSON(w, http.StatusBadRequest, envelope{Error: strPtr(ErrMissingArtistAndTitle)})
		return
	}

	explicit := r.URL.Query().Get("explicit") != "false"
	quality := 256
	if parsedQuality, err := strconv.Atoi(r.URL.Query().Get("quality")); err == nil {
		quality = parsedQuality
	}

	streamURL, err := h.trackUC.GetYouTubeStreamURL(r.Context(), artist, title, explicit, quality)
	if err == nil && h.executeProxy(w, r, streamURL) {
		return
	}

	h.trackUC.InvalidateStreamURL(r.Context(), artist, title)
	freshURL, freshErr := h.trackUC.GetFreshStreamURL(r.Context(), artist, title, explicit)
	if freshErr == nil && freshURL != "" && h.executeProxy(w, r, freshURL) {
		return
	}

	writeJSON(w, http.StatusBadGateway, envelope{Error: strPtr("Failed to proxy stream")})
}

func (h *Handler) executeProxy(w http.ResponseWriter, r *http.Request, streamURL string) bool {
	proxyReq, err := http.NewRequestWithContext(r.Context(), r.Method, streamURL, nil)
	if err != nil {
		return false
	}
	proxyReq.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")
	if strings.Contains(streamURL, "saavn") {
		proxyReq.Header.Set("Referer", "https://www.jiosaavn.com/")
	}
	if rangeHeader := r.Header.Get("Range"); rangeHeader != "" {
		proxyReq.Header.Set("Range", rangeHeader)
	}

	client := &http.Client{
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			if len(via) > 0 && via[0].Header.Get("Range") != "" {
				req.Header.Set("Range", via[0].Header.Get("Range"))
			}
			return nil
		},
	}
	resp, err := client.Do(proxyReq)
	if err != nil || resp.StatusCode >= 400 {
		if resp != nil {
			_ = resp.Body.Close()
		}
		return false
	}
	defer resp.Body.Close()

	for _, headerName := range []string{"Content-Length", "Accept-Ranges", "Content-Range"} {
		if val := resp.Header.Get(headerName); val != "" {
			w.Header().Set(headerName, val)
		}
	}
	setStreamContentType(w, resp.Header.Get("Content-Type"), streamURL)
	w.Header().Set("Accept-Ranges", "bytes")
	w.Header().Set("Cache-Control", "public, max-age=86400, immutable")
	w.WriteHeader(resp.StatusCode)

	if r.Method != http.MethodHead {
		if _, copyErr := io.Copy(w, resp.Body); copyErr != nil {
			log.Printf("stream proxy disconnected: %v", copyErr)
		}
	}
	return true
}

func setStreamContentType(w http.ResponseWriter, headerVal, streamURL string) {
	ct := strings.ToLower(headerVal)
	if strings.Contains(ct, "webm") {
		w.Header().Set("Content-Type", "audio/webm")
	} else if strings.Contains(ct, "mpeg") || strings.Contains(ct, "mp3") || strings.Contains(streamURL, ".mp3") || strings.Contains(streamURL, "dzcdn") {
		w.Header().Set("Content-Type", "audio/mpeg")
	} else {
		w.Header().Set("Content-Type", "audio/mp4")
	}
}
