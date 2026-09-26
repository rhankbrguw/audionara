package http

import (
	"errors"
	"net/http"
	"strconv"

	"github.com/user/audionara/backend/internal/usecase"
	apperrors "github.com/user/audionara/backend/pkg/errors"
)

func parseAudioParams(r *http.Request) (bool, int) {
	explicit := r.URL.Query().Get("explicit") != "false"
	quality := 256
	if q, err := strconv.Atoi(r.URL.Query().Get("quality")); err == nil {
		quality = q
	}
	return explicit, quality
}

// getAlbumDetail handles GET /api/v1/albums/{id}/tracks
func (h *Handler) getAlbumDetail(w http.ResponseWriter, r *http.Request) {
	albumID := r.PathValue("id")
	if albumID == "" {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, apperrors.MsgAlbumIDRequired))
		return
	}

	explicit, quality := parseAudioParams(r)
	detail, err := h.trackUC.GetAlbumDetail(r.Context(), albumID, explicit, quality)
	if err != nil {
		if errors.Is(err, usecase.ErrEmptyVibe) {
			writeError(w, apperrors.NewAppError(http.StatusBadRequest, apperrors.MsgAlbumIDEmpty))
			return
		}
		writeError(w, apperrors.NewAppError(http.StatusNotFound, ErrAlbumNotFound))
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: detail})
}

// getArtistTopSongs handles GET /api/v1/artists/{id}/tracks
func (h *Handler) getArtistTopSongs(w http.ResponseWriter, r *http.Request) {
	artistID := r.PathValue("id")
	if artistID == "" {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrMissingArtistID))
		return
	}

	explicit, quality := parseAudioParams(r)
	tracks, err := h.trackUC.GetArtistTopSongs(r.Context(), artistID, explicit, quality)
	if err != nil {
		writeError(w, apperrors.NewAppError(http.StatusNotFound, ErrArtistNotFound))
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: tracks})
}

// getArtistDetail handles GET /api/v1/artists/{id}/detail
func (h *Handler) getArtistDetail(w http.ResponseWriter, r *http.Request) {
	artistID := r.PathValue("id")
	if artistID == "" {
		artistID = r.URL.Query().Get("id")
	}
	if artistID == "" {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrMissingArtistID))
		return
	}

	explicit, quality := parseAudioParams(r)
	detail, err := h.trackUC.GetArtistDetail(r.Context(), artistID, explicit, quality)
	if err != nil {
		writeError(w, apperrors.NewAppError(http.StatusNotFound, ErrArtistNotFound))
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: detail})
}

