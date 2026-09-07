package http

import (
	"net/http"
	"strconv"
)

// getHomeFeed handles GET /api/v1/home/feed
func (h *Handler) getHomeFeed(w http.ResponseWriter, r *http.Request) {
	deviceID := r.URL.Query().Get("device_id")
	if deviceID == "" {
		deviceID = r.Header.Get("X-Device-ID")
	}
	seedStr := r.URL.Query().Get("seed")
	seed := 0
	if seedStr != "" {
		if s, err := strconv.Atoi(seedStr); err == nil {
			seed = s
		}
	}
	forceRefresh := r.URL.Query().Get("refresh") == "true"
	feed, err := h.homeUC.GetHomeFeed(r.Context(), deviceID, seed, forceRefresh)
	if err != nil {
		feed = h.homeUC.GetHomeFeedFallback()
	}

	writeJSON(w, http.StatusOK, envelope{Data: feed})
}
