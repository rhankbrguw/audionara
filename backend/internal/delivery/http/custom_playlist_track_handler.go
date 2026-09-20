package http

import (
	"encoding/json"
	"net/http"
	"strings"

	"github.com/user/audionara/backend/internal/domain"
	apperrors "github.com/user/audionara/backend/pkg/errors"
)

// addTrackToCustomPlaylist adds a track to a specific custom playlist.
func (h *Handler) addTrackToCustomPlaylist(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)
	playlistID := r.PathValue("id")

	var track domain.CustomPlaylistTrack
	if err := json.NewDecoder(r.Body).Decode(&track); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	track.Title = strings.TrimSpace(track.Title)
	track.Artist = strings.TrimSpace(track.Artist)
	track.StreamURL = strings.TrimSpace(track.StreamURL)
	track.CoverArt = strings.TrimSpace(track.CoverArt)

	err := h.playlistUC.AddTrackToCustomPlaylist(userID, playlistID, &track)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusCreated, envelope{Data: map[string]bool{"success": true}})
}

// removeTrackFromCustomPlaylist removes a track from a custom playlist.
func (h *Handler) removeTrackFromCustomPlaylist(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)
	playlistID := r.PathValue("id")
	trackID := r.PathValue("trackId")

	err := h.playlistUC.RemoveTrackFromCustomPlaylist(userID, playlistID, trackID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: map[string]bool{"success": true}})
}

// getCustomPlaylistTracks retrieves all tracks from a specific custom playlist.
func (h *Handler) getCustomPlaylistTracks(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)
	playlistID := r.PathValue("id")

	tracks, err := h.playlistUC.GetCustomPlaylistTracks(userID, playlistID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: tracks})
}
