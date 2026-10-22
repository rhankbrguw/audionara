package http

import (
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	apperrors "github.com/user/audionara/backend/pkg/errors"
)

// getPlaylist retrieves the saved tracks (default library) for the current user.
func (h *Handler) getPlaylist(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)

	tracks, err := h.playlistUC.GetSavedTracks(userID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: tracks})
}

// togglePlaylist adds or removes a track from the user's default playlist.
func (h *Handler) togglePlaylist(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)

	var track domain.PlaylistTrack
	if err := json.NewDecoder(r.Body).Decode(&track); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	track.Title = strings.TrimSpace(track.Title)
	track.Artist = strings.TrimSpace(track.Artist)
	track.StreamURL = strings.TrimSpace(track.StreamURL)
	track.CoverArt = strings.TrimSpace(track.CoverArt)

	track.UserID = userID
	if track.AddedAt.IsZero() {
		track.AddedAt = time.Now()
	}

	isSavedNow, err := h.playlistUC.ToggleTrack(&track)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: map[string]bool{"isSaved": isSavedNow}})
}

// getTrackStatus checks if a track is saved in the user's default playlist.
func (h *Handler) getTrackStatus(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)

	trackID := strings.TrimSpace(r.URL.Query().Get("trackId"))
	if trackID == "" {
		writeError(w, apperrors.NewAppError(http.StatusBadRequest, ErrMissingTrackID))
		return
	}

	isSaved, err := h.playlistUC.IsTrackSaved(userID, trackID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: map[string]bool{"isSaved": isSaved}})
}
