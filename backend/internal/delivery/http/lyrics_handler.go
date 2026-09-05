package http

import (
	"net/http"
	"strings"

	apperrors "github.com/user/audionara/backend/pkg/errors"
)

// getLyrics handles GET /api/v1/tracks/lyrics?artist=...&title=...
func (h *Handler) getLyrics(w http.ResponseWriter, r *http.Request) {
	artist := strings.TrimSpace(r.URL.Query().Get("artist"))
	title := strings.TrimSpace(r.URL.Query().Get("title"))

	if artist == "" || title == "" {
		writeJSON(w, http.StatusBadRequest, envelope{Error: strPtr(ErrMissingArtistAndTitle)})
		return
	}

	lyrics, err := h.trackUC.GetLyrics(r.Context(), artist, title)
	if err != nil {
		if strings.Contains(err.Error(), "not found") {
			writeJSON(w, http.StatusNotFound, envelope{Error: strPtr(ErrLyricsNotFound)})
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: lyrics})
}
