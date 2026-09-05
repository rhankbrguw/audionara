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

// register handles new user registration.
func (h *Handler) register(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Username string `json:"username"`
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Username = strings.TrimSpace(req.Username)
	req.Email = strings.TrimSpace(req.Email)

	if err := validator.ValidateUsername(req.Username); err != nil {
		writeError(w, err)
		return
	}
	if err := validator.ValidateEmail(req.Email); err != nil {
		writeError(w, err)
		return
	}
	if err := validator.ValidatePassword(req.Password); err != nil {
		writeError(w, err)
		return
	}

	res, err := h.userUC.Register(req.Username, req.Email, req.Password)
	if err != nil {
		if errors.Is(err, usecase.ErrUserExists) {
			writeError(w, apperrors.NewAppError(http.StatusConflict, apperrors.MsgEmailAlreadyAssociated))
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	writeJSON(w, http.StatusCreated, envelope{Data: res})
}

// verifyEmail handles email verification using an OTP.
func (h *Handler) verifyEmail(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Email string `json:"email"`
		OTP   string `json:"otp"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeError(w, apperrors.ErrInvalidRequestFormat)
		return
	}
	req.Email = strings.TrimSpace(req.Email)
	req.OTP = strings.TrimSpace(req.OTP)

	if err := validator.ValidateOTP(req.OTP); err != nil {
		writeError(w, err)
		return
	}

	res, err := h.userUC.VerifyEmail(req.Email, req.OTP)
	if err != nil {
		if errors.Is(err, usecase.ErrInvalidToken) || errors.Is(err, usecase.ErrInvalidCredentials) {
			writeError(w, apperrors.NewAppError(http.StatusUnauthorized, apperrors.MsgInvalidVerificationOTP))
			return
		}
		writeError(w, apperrors.ErrInternalServer)
		return
	}
	writeJSON(w, http.StatusOK, envelope{Data: res})
}
