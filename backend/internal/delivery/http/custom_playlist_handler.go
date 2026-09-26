package http

import (
	"encoding/json"
	"net/http"
	"strings"

	apperrors "github.com/user/audionara/backend/pkg/errors"
)

// createCustomPlaylist creates a new custom playlist for the user.
func (h *Handler) createCustomPlaylist(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)

	var req struct {
		Name        string `json:"name"`
		Bio         string `json:"bio"`
		CoverArtURL string `json:"coverArtUrl"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Name = strings.TrimSpace(req.Name)
	req.Bio = strings.TrimSpace(req.Bio)
	req.CoverArtURL = strings.TrimSpace(req.CoverArtURL)

	playlist, err := h.playlistUC.CreateCustomPlaylist(userID, req.Name, req.Bio, req.CoverArtURL)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusCreated, envelope{Data: playlist})
}

// getCustomPlaylists retrieves all custom playlists for the user.
func (h *Handler) getCustomPlaylists(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)

	playlists, err := h.playlistUC.GetCustomPlaylists(userID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: playlists})
}

// updateCustomPlaylist updates the details of a specific custom playlist.
func (h *Handler) updateCustomPlaylist(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)
	playlistID := r.PathValue("id")

	var req struct {
		Name        string `json:"name"`
		Bio         string `json:"bio"`
		CoverArtURL string `json:"coverArtUrl"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Name = strings.TrimSpace(req.Name)
	req.Bio = strings.TrimSpace(req.Bio)
	req.CoverArtURL = strings.TrimSpace(req.CoverArtURL)

	playlist, err := h.playlistUC.UpdateCustomPlaylist(userID, playlistID, req.Name, req.Bio, req.CoverArtURL)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: playlist})
}

// deleteCustomPlaylist removes a user's custom playlist.
func (h *Handler) deleteCustomPlaylist(w http.ResponseWriter, r *http.Request) {
	userID := r.Context().Value(UserIDKey).(string)
	playlistID := r.PathValue("id")

	err := h.playlistUC.DeleteCustomPlaylist(userID, playlistID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	writeJSON(w, http.StatusOK, envelope{Data: map[string]bool{"success": true}})
}
