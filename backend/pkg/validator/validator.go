// Package validator provides input validation helpers for the HTTP layer.
package validator

import (
	"net/http"
	"regexp"
	"strings"
	"unicode"

	"github.com/user/audionara/backend/pkg/errors"
)

var (
	emailRegex    = regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)
	otpRegex      = regexp.MustCompile(`^\d{6}$`)
	usernameRegex = regexp.MustCompile(`^[a-zA-Z0-9][a-zA-Z0-9._-]{1,28}[a-zA-Z0-9]$`)
	nameRegex     = regexp.MustCompile(`^[a-zA-Z\s'-]{2,50}$`)
	phoneRegex    = regexp.MustCompile(`^\+?[0-9]{8,15}$`)

	commonEmailTypos = []string{
		"@gmail.co", "@gmail.con", "@gmai.com", "@gmal.com",
		"@yahoo.co", "@yahoo.con", "@hotmail.co", "@hotmail.con",
	}
)

// ValidateEmail checks for a properly formatted email address and common typos.
func ValidateEmail(email string) *errors.AppError {
	if email == "" {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgEmailRequired)
	}
	if !emailRegex.MatchString(email) {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgEmailInvalidFormat)
	}

	lowerEmail := strings.ToLower(email)
	for _, typo := range commonEmailTypos {
		if strings.HasSuffix(lowerEmail, typo) {
			idx := strings.Index(lowerEmail, "@")
			if idx != -1 && len(lowerEmail)-idx == len(typo) {
				return errors.NewAppError(http.StatusBadRequest, errors.MsgEmailTypo)
			}
		}
	}
	return nil
}

// ValidatePassword enforces strong password requirements.
func ValidatePassword(password string) *errors.AppError {
	if len(password) < 8 {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgPasswordShort)
	}

	var hasUpper, hasDigit bool
	for _, ch := range password {
		switch {
		case unicode.IsUpper(ch):
			hasUpper = true
		case unicode.IsDigit(ch):
			hasDigit = true
		}
	}

	if !hasUpper {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgPasswordNoUpper)
	}
	if !hasDigit {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgPasswordNoDigit)
	}
	return nil
}

// ValidateUsername checks username syntax and length bounds.
func ValidateUsername(username string) *errors.AppError {
	if len(username) < 3 {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgUsernameShort)
	}
	if len(username) > 30 {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgUsernameLong)
	}
	if !usernameRegex.MatchString(username) {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgUsernameFormat)
	}
	return nil
}

// ValidateName ensures name contains only valid letters and symbols without numbers.
func ValidateName(name string) *errors.AppError {
	if name == "" {
		return nil
	}
	if !nameRegex.MatchString(name) {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgNameInvalidFormat)
	}
	return nil
}

// ValidatePhone ensures phone number contains only numeric characters.
func ValidatePhone(phone string) *errors.AppError {
	if phone == "" {
		return nil
	}
	if !phoneRegex.MatchString(phone) {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgPhoneInvalidFormat)
	}
	return nil
}

// ValidatePlaylistName validates custom playlist title bounds.
func ValidatePlaylistName(name string) *errors.AppError {
	trimmed := strings.TrimSpace(name)
	if trimmed == "" {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgPlaylistNameEmpty)
	}
	if len(trimmed) > 50 {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgPlaylistNameLong)
	}
	return nil
}

// ValidateBio validates user or playlist description length.
func ValidateBio(bio string) *errors.AppError {
	if len(bio) > 250 {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgBioLong)
	}
	return nil
}

// ValidateOTP checks that the OTP is exactly 6 numeric digits.
func ValidateOTP(otp string) *errors.AppError {
	if !otpRegex.MatchString(otp) {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgInvalidOTPFormat)
	}
	return nil
}

// ValidateToken checks reset token length.
func ValidateToken(token string) *errors.AppError {
	if len(token) < 8 {
		return errors.NewAppError(http.StatusBadRequest, errors.MsgInvalidTokenFormat)
	}
	return nil
}
