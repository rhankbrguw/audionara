package http

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/user/audionara/backend/internal/usecase"
	apperrors "github.com/user/audionara/backend/pkg/errors"
)

// searchTracks handles GET /api/v1/tracks/search?term=<term>.
func (h *Handler) searchTracks(w http.ResponseWriter, r *http.Request) {
	vibe := strings.TrimSpace(r.URL.Query().Get("term"))
	if vibe == "" {
		vibe = strings.TrimSpace(r.URL.Query().Get("vibe"))
	}
	if vibe == "" {
		vibe = "synthwave" // Graceful fallback
	}

	limitStr := r.URL.Query().Get("limit")
	limit := 20
	if limitStr != "" {
		fmt.Sscanf(limitStr, "%d", &limit)
	}

	offsetStr := r.URL.Query().Get("offset")
	offset := 0
	if offsetStr != "" {
		fmt.Sscanf(offsetStr, "%d", &offset)
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

	tracks, err := h.trackUC.SearchByVibe(r.Context(), vibe, limit, offset, explicit, quality)
	if err != nil {
		if errors.Is(err, usecase.ErrEmptyVibe) {
			writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrSearchVibeEmpty))
			return
		}
		log.Println("Search error:", err)
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: tracks, Error: nil})
}

// rawSearch handles GET /api/v1/tracks/search/raw.
func (h *Handler) rawSearch(w http.ResponseWriter, r *http.Request) {
	query := strings.TrimSpace(r.URL.Query().Get("q"))
	if query == "" {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrSearchQueryRequired))
		return
	}

	limitStr := r.URL.Query().Get("limit")
	limit := 30
	if limitStr != "" {
		fmt.Sscanf(limitStr, "%d", &limit)
	}

	offsetStr := r.URL.Query().Get("offset")
	offset := 0
	if offsetStr != "" {
		fmt.Sscanf(offsetStr, "%d", &offset)
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

	tracks, err := h.trackUC.SearchRaw(r.Context(), query, limit, offset, explicit, quality)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: tracks, Error: nil})
}

// multiSearch handles GET /api/v1/tracks/search/multi?q=<query>.
// Returns songs, albums, and artists grouped under a single response.
func (h *Handler) multiSearch(w http.ResponseWriter, r *http.Request) {
	query := strings.TrimSpace(r.URL.Query().Get("q"))
	if query == "" {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrSearchQueryRequired))
		return
	}

	limitStr := r.URL.Query().Get("limit")
	limit := 90
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

	result, err := h.trackUC.SearchMulti(r.Context(), query, limit, explicit, quality)
	if err != nil {
		if errors.Is(err, usecase.ErrEmptyVibe) {
			writeError(w, apperrors.NewAppError(http.StatusBadRequest, apperrors.MsgSearchQueryEmpty))
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: result, Error: nil})
}
