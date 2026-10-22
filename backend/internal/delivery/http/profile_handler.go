package http

import (
	"encoding/json"
	"errors"
	"net/http"
	"strings"

	"github.com/user/audionara/backend/internal/usecase"
	apperrors "github.com/user/audionara/backend/pkg/errors"
	"github.com/user/audionara/backend/pkg/validator"
)

// getProfile retrieves the current user's profile.
func (h *Handler) getProfile(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value(UserIDKey).(string)
	if !ok || userID == "" {
		writeError(w, apperrors.NewAppError(http.StatusUnauthorized, apperrors.MsgInvalidSessionContext))
		return
	}
	user, err := h.userUC.GetProfile(userID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	if user == nil {
		writeError(w, apperrors.NewAppError(http.StatusNotFound, apperrors.MsgUserNotFound))
		return
	}
	writeJSON(w, http.StatusOK, envelope{Data: user})
}

// updateProfile updates the current user's profile information.
func (h *Handler) updateProfile(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value(UserIDKey).(string)
	if !ok || userID == "" {
		writeError(w, apperrors.NewAppError(http.StatusUnauthorized, apperrors.MsgInvalidSessionContext))
		return
	}
	var req struct {
		Username          string `json:"username"`
		Email             string `json:"email"`
		Bio               string `json:"bio"`
		ProfilePictureUrl string `json:"profilePictureUrl"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Username = strings.TrimSpace(req.Username)
	req.Email = strings.TrimSpace(req.Email)
	req.Bio = strings.TrimSpace(req.Bio)
	req.ProfilePictureUrl = strings.TrimSpace(req.ProfilePictureUrl)

	if req.Email != "" {
		if err := validator.ValidateEmail(req.Email); err != nil {
			writeError(w, err)
			return
		}
	}
	if req.Username != "" {
		if err := validator.ValidateUsername(req.Username); err != nil {
			writeError(w, err)
			return
		}
	}

	if err := h.userUC.UpdateProfile(userID, req.Username, req.Email, req.Bio, req.ProfilePictureUrl); err != nil {
		if errors.Is(err, usecase.ErrUserExists) {
			writeError(w, apperrors.NewAppError(http.StatusConflict, apperrors.MsgEmailAlreadyAssociated))
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}

	updatedUser, err := h.userUC.GetProfile(userID)
	if err != nil {
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	writeJSON(w, http.StatusOK, envelope{Data: updatedUser})
}

// changePassword updates user's password.
func (h *Handler) changePassword(w http.ResponseWriter, r *http.Request) {
	userID, ok := r.Context().Value(UserIDKey).(string)
	if !ok || userID == "" {
		writeError(w, apperrors.NewAppError(http.StatusUnauthorized, apperrors.MsgInvalidSessionContext))
		return
	}
	var req struct {
		CurrentPassword string `json:"currentPassword"`
		NewPassword     string `json:"newPassword"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	if err := validator.ValidatePassword(req.NewPassword); err != nil {
		writeError(w, err)
		return
	}
	if err := h.userUC.ChangePassword(userID, req.CurrentPassword, req.NewPassword); err != nil {
		if errors.Is(err, usecase.ErrInvalidCredentials) {
			writeError(w, apperrors.NewAppError(http.StatusUnauthorized, apperrors.MsgInvalidCreds))
			return
		} else if errors.Is(err, usecase.ErrSameAsOldPassword) {
			writeError(w, apperrors.NewAppError(http.StatusUnprocessableEntity, apperrors.MsgSameAsOldPassword))
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	writeJSON(w, http.StatusOK, envelope{Data: "Password successfully updated."})
}
