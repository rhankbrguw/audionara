package http

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"

	"github.com/user/audionara/backend/internal/domain"
	apperrors "github.com/user/audionara/backend/pkg/errors"
)

// logHistory handles POST /api/v1/tracks/history
func (h *Handler) logHistory(w http.ResponseWriter, r *http.Request) {
	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		deviceID = r.URL.Query().Get("device_id")
	}
	if deviceID == "" {
		deviceID = r.RemoteAddr
	}

	var payload domain.HistoryRecord
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrInvalidPayload))
		return
	}
	payload.DeviceID = deviceID

	if err := h.trackUC.LogPlay(r.Context(), &payload); err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	writeJSON(w, http.StatusOK, envelope{Data: "ok", Error: nil})
}

// recordMetric handles POST /api/v1/tracks/metrics.
func (h *Handler) recordMetric(w http.ResponseWriter, r *http.Request) {
	var payload struct {
		TrackID string `json:"track_id"`
		Vibe    string `json:"vibe"`
		Action  string `json:"action"` // "skip" or "complete"
	}
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrInvalidPayload))
		return
	}
	payload.TrackID = strings.TrimSpace(payload.TrackID)
	payload.Vibe = strings.TrimSpace(payload.Vibe)
	payload.Action = strings.TrimSpace(payload.Action)

	h.trackUC.RecordMetric(payload.TrackID, payload.Vibe, payload.Action)
	writeJSON(w, http.StatusOK, envelope{Data: "ok", Error: nil})
}

// mixForYou handles GET /api/v1/tracks/mix.
func (h *Handler) mixForYou(w http.ResponseWriter, r *http.Request) {
	limitStr := r.URL.Query().Get("limit")
	limit := 30
	if limitStr != "" {
		fmt.Sscanf(limitStr, "%d", &limit)
	}

	explicitStr := r.URL.Query().Get("explicit")
	explicit := true
	if explicitStr == "false" {
		explicit = false
	}

	qualityStr := r.URL.Query().Get("quality")
	quality := 256
	if q, err := strconv.Atoi(qualityStr); err == nil {
		quality = q
	}

	deviceID := r.Header.Get("X-Device-ID")
	if deviceID == "" {
		deviceID = r.URL.Query().Get("device_id")
	}

	tracks, err := h.trackUC.GetMixForYou(r.Context(), deviceID, limit, explicit, quality)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: tracks, Error: nil})
}
