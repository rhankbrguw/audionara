package http

import (
	"net/http"
)

// getHomeFeed handles GET /api/v1/home/feed
func (h *Handler) getHomeFeed(w http.ResponseWriter, r *http.Request) {
	deviceID := r.URL.Query().Get("device_id")
	if deviceID == "" {
		deviceID = r.Header.Get("X-Device-ID")
	}
	feed, err := h.homeUC.GetHomeFeed(r.Context(), deviceID)
	if err != nil {
		feed = h.homeUC.GetHomeFeedFallback()
	}

	writeJSON(w, http.StatusOK, envelope{Data: feed})
}
