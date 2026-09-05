package http

import (
	"io"
	"log"
	"net/http"
	"strconv"
	"strings"
)

// getStream proxies the resolved audio stream URL.
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
	if err != nil {
		log.Printf("GetYouTubeStreamURL error: %v", err)
		writeJSON(w, http.StatusInternalServerError, envelope{Error: strPtr(ErrFailedToFetchStream)})
		return
	}

	h.proxyStream(w, r, streamURL)
}

func (h *Handler) proxyStream(w http.ResponseWriter, r *http.Request, streamURL string) {
	proxyReq, err := http.NewRequestWithContext(r.Context(), r.Method, streamURL, nil)
	if err != nil {
		writeJSON(w, http.StatusInternalServerError, envelope{Error: strPtr("Failed to create proxy request")})
		return
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
			resp.Body.Close()
		}
		writeJSON(w, http.StatusBadGateway, envelope{Error: strPtr("Failed to proxy stream")})
		return
	}
	defer resp.Body.Close()

	for _, headerName := range []string{"Content-Length", "Accept-Ranges", "Content-Range"} {
		if headerValue := resp.Header.Get(headerName); headerValue != "" {
			w.Header().Set(headerName, headerValue)
		}
	}
	contentType := strings.ToLower(resp.Header.Get("Content-Type"))
	if strings.Contains(contentType, "webm") {
		w.Header().Set("Content-Type", "audio/webm")
	} else if strings.Contains(contentType, "mpeg") || strings.Contains(contentType, "mp3") || strings.Contains(streamURL, ".mp3") || strings.Contains(streamURL, "dzcdn") {
		w.Header().Set("Content-Type", "audio/mpeg")
	} else if strings.Contains(contentType, "mp4") || strings.Contains(contentType, "m4a") || strings.Contains(contentType, "aac") || strings.Contains(streamURL, ".m4a") || strings.Contains(streamURL, ".mp4") {
		w.Header().Set("Content-Type", "audio/mp4")
	} else {
		w.Header().Set("Content-Type", "audio/mp4")
	}
	w.Header().Set("Accept-Ranges", "bytes")
	w.Header().Set("Cache-Control", "public, max-age=86400, immutable")
	w.WriteHeader(resp.StatusCode)

	if r.Method != http.MethodHead {
		if _, copyErr := io.Copy(w, resp.Body); copyErr != nil {
			log.Printf("stream proxy disconnected: %v", copyErr)
		}
	}
}
