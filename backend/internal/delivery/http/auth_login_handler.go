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

// login handles user authentication.
func (h *Handler) login(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Email = strings.TrimSpace(req.Email)

	if err := validator.ValidateEmail(req.Email); err != nil {
		writeError(w, err)
		return
	}

	res, err := h.userUC.Login(req.Email, req.Password)
	if err != nil {
		if errors.Is(err, usecase.ErrInvalidCredentials) {
			writeError(w, apperrors.NewAppError(http.StatusUnauthorized, apperrors.MsgInvalidCreds))
			return
		} else if errors.Is(err, usecase.ErrEmailNotVerified) {
			writeError(w, apperrors.NewAppError(http.StatusForbidden, apperrors.MsgEmailNotVerified))
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	writeJSON(w, http.StatusOK, envelope{Data: res})
}

// forgotPassword triggers a password reset email if the user exists.
func (h *Handler) forgotPassword(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Email string `json:"email"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Email = strings.TrimSpace(req.Email)

	if err := validator.ValidateEmail(req.Email); err != nil {
		writeError(w, err)
		return
	}

	// Always returns 200 OK to prevent email enumeration
	_ = h.userUC.ForgotPassword(req.Email)
	writeJSON(w, http.StatusOK, envelope{Data: "If the email exists, an OTP was sent."})
}

// resetPassword validates the OTP and updates the user's password.
func (h *Handler) resetPassword(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Email       string `json:"email"`
		OTP         string `json:"otp"`
		NewPassword string `json:"newPassword"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Email = strings.TrimSpace(req.Email)
	req.OTP = strings.TrimSpace(req.OTP)

	if err := validator.ValidateEmail(req.Email); err != nil {
		writeError(w, err)
		return
	}
	if err := validator.ValidateOTP(req.OTP); err != nil {
		writeError(w, err)
		return
	}
	if err := validator.ValidatePassword(req.NewPassword); err != nil {
		writeError(w, err)
		return
	}

	if err := h.userUC.ResetPassword(req.Email, req.OTP, req.NewPassword); err != nil {
		if errors.Is(err, usecase.ErrInvalidToken) {
			writeError(w, apperrors.NewAppError(http.StatusUnauthorized, apperrors.MsgInvalidResetOTP))
			return
		} else if errors.Is(err, usecase.ErrSameAsOldPassword) {
			writeError(w, apperrors.NewAppError(http.StatusUnprocessableEntity, apperrors.MsgSameAsOldPassword))
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	writeJSON(w, http.StatusOK, envelope{Data: "Password reset successful."})
}
