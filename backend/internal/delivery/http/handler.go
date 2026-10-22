// Package http contains the HTTP delivery adapters.
package http

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/usecase"
	"github.com/user/audionara/backend/pkg/errors"
)

// ResponseMeta contains metadata for standard API envelopes with unified pagination.
type ResponseMeta struct {
	Page      int    `json:"page,omitempty"`
	Limit     int    `json:"limit,omitempty"`
	Total     int    `json:"total,omitempty"`
	HasMore   bool   `json:"has_more,omitempty"`
	Timestamp string `json:"timestamp"`
}

// APIResponse represents the industry-grade unified JSON envelope.
type APIResponse struct {
	Success bool                `json:"success"`
	Code    string              `json:"code"`
	Message string              `json:"message"`
	Data    any                 `json:"data,omitempty"`
	Errors  map[string][]string `json:"errors,omitempty"`
	Meta    ResponseMeta        `json:"meta"`
}

// envelope maintains backward compatibility for existing handler payload signatures.
type envelope struct {
	Data  any     `json:"data,omitempty"`
	Error *string `json:"error,omitempty"`
}

// Handler handles track requests.
type Handler struct {
	trackUC    *usecase.TrackUseCase
	playlistUC domain.PlaylistUseCase
	userUC     domain.UserUseCase
	homeUC     *usecase.HomeUseCase
}

// NewHandler constructs a new Handler.
func NewHandler(trackUC *usecase.TrackUseCase, playlistUC domain.PlaylistUseCase, userUC domain.UserUseCase, homeUC *usecase.HomeUseCase) *Handler {
	return &Handler{trackUC: trackUC, playlistUC: playlistUC, userUC: userUC, homeUC: homeUC}
}

// RegisterRoutes mounts all handlers onto the provided mux.
func (h *Handler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("GET /api/v1/tracks/search", h.searchTracks)
	mux.HandleFunc("GET /api/v1/tracks/search/raw", h.rawSearch)
	mux.HandleFunc("GET /api/v1/tracks/search/multi", h.multiSearch)
	mux.HandleFunc("GET /api/v1/tracks/mix", h.mixForYou)
	mux.HandleFunc("GET /api/v1/home/feed", h.getHomeFeed)
	mux.HandleFunc("GET /api/v1/tracks/album", h.getAlbumDetail)
	mux.HandleFunc("GET /api/v1/tracks/artist-top-songs", h.getArtistTopSongs)
	mux.HandleFunc("GET /api/v1/tracks/lyrics", h.getLyrics)
	mux.HandleFunc("GET /api/v1/tracks/stream.m4a", h.getStream)
	mux.HandleFunc("HEAD /api/v1/tracks/stream.m4a", h.getStream)
	mux.HandleFunc("POST /api/v1/tracks/metrics", h.recordMetric)
	mux.HandleFunc("POST /api/v1/tracks/history", h.logHistory)

	// Lookup routes
	mux.HandleFunc("GET /api/v1/albums/{id}/tracks", h.getAlbumDetail)
	mux.HandleFunc("GET /api/v1/artists/{id}/tracks", h.getArtistTopSongs)
	mux.HandleFunc("GET /api/v1/artists/{id}/detail", h.getArtistDetail)
	mux.HandleFunc("GET /api/v1/tracks/artist-detail", h.getArtistDetail)


	// Auth routes
	mux.HandleFunc("POST /api/v1/auth/register", h.register)
	mux.HandleFunc("POST /api/v1/auth/verify-email", h.verifyEmail)
	mux.HandleFunc("POST /api/v1/auth/login", h.login)
	mux.HandleFunc("POST /api/v1/auth/forgot-password", h.forgotPassword)
	mux.HandleFunc("POST /api/v1/auth/reset-password", h.resetPassword)

	// User Profile routes
	mux.HandleFunc("GET /api/v1/profile", AuthMiddleware(h.getProfile))
	mux.HandleFunc("PUT /api/v1/profile", AuthMiddleware(h.updateProfile))
	mux.HandleFunc("POST /api/v1/profile/change-password", AuthMiddleware(h.changePassword))

	// Protected Playlist routes
	mux.HandleFunc("GET /api/v1/playlist", AuthMiddleware(h.getPlaylist))
	mux.HandleFunc("POST /api/v1/playlist/toggle", AuthMiddleware(h.togglePlaylist))
	mux.HandleFunc("GET /api/v1/playlist/status", AuthMiddleware(h.getTrackStatus))

	// Custom Playlists routes
	mux.HandleFunc("POST /api/v1/custom-playlists", AuthMiddleware(h.createCustomPlaylist))
	mux.HandleFunc("GET /api/v1/custom-playlists", AuthMiddleware(h.getCustomPlaylists))
	mux.HandleFunc("PUT /api/v1/custom-playlists/{id}", AuthMiddleware(h.updateCustomPlaylist))
	mux.HandleFunc("DELETE /api/v1/custom-playlists/{id}", AuthMiddleware(h.deleteCustomPlaylist))
	mux.HandleFunc("POST /api/v1/custom-playlists/{id}/tracks", AuthMiddleware(h.addTrackToCustomPlaylist))
	mux.HandleFunc("DELETE /api/v1/custom-playlists/{id}/tracks/{trackId}", AuthMiddleware(h.removeTrackFromCustomPlaylist))
	mux.HandleFunc("GET /api/v1/custom-playlists/{id}/tracks", AuthMiddleware(h.getCustomPlaylistTracks))

	// Upload route
	mux.HandleFunc("POST /api/v1/upload", AuthMiddleware(h.uploadFile))
}

func writeJSON(w http.ResponseWriter, status int, payload any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)

	if env, ok := payload.(envelope); ok {
		if env.Error != nil {
			_ = json.NewEncoder(w).Encode(APIResponse{
				Success: false,
				Code:    errors.CodeBadRequest,
				Message: *env.Error,
				Meta:    ResponseMeta{Timestamp: time.Now().UTC().Format(time.RFC3339)},
			})
			return
		}
		_ = json.NewEncoder(w).Encode(APIResponse{
			Success: true,
			Code:    errors.CodeOK,
			Message: "Success",
			Data:    env.Data,
			Meta:    ResponseMeta{Timestamp: time.Now().UTC().Format(time.RFC3339)},
		})
		return
	}

	_ = json.NewEncoder(w).Encode(payload)
}

func writeError(w http.ResponseWriter, err *errors.AppError) {
	w.Header().Set("Content-Type", "application/json")
	status := err.HTTPStatus
	if status == 0 {
		status = http.StatusInternalServerError
	}
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(APIResponse{
		Success: false,
		Code:    err.Code,
		Message: err.Message,
		Errors:  err.Errors,
		Meta:    ResponseMeta{Timestamp: time.Now().UTC().Format(time.RFC3339)},
	})
}

func strPtr(s string) *string { return &s }
