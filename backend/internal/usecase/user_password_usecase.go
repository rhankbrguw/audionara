package usecase

import (
	"time"

	"github.com/google/uuid"
	"github.com/user/audionara/backend/internal/domain"
	"golang.org/x/crypto/bcrypt"
)

// VerifyEmail provides VerifyEmail functionality.
func (uc *userUseCase) VerifyEmail(email, otp string) (*domain.AuthResponse, error) {
	user, err := uc.repo.GetUserByEmail(email)
	if err != nil || user == nil {
		return nil, ErrInvalidCredentials
	}

	tokens, err := uc.repo.GetVerificationTokensByUserID(user.ID, "EMAIL_VERIFY")
	if err != nil {
		return nil, err
	}

	var validToken *domain.VerificationToken
	for _, t := range tokens {
		if t.ExpiresAt.After(time.Now()) {
			if err := bcrypt.CompareHashAndPassword([]byte(t.TokenHash), []byte(otp)); err == nil {
				validToken = t
				break
			}
		}
	}

	if validToken == nil {
		return nil, ErrInvalidToken
	}

	// Update user
	user.IsEmailVerified = true
	if err := uc.repo.UpdateUser(user); err != nil {
		return nil, err
	}

	// Delete token
	uc.repo.DeleteVerificationToken(validToken.ID)

	// Generate JWT
	jwtToken, err := uc.generateJWT(user.ID)
	if err != nil {
		return nil, err
	}

	return &domain.AuthResponse{Token: jwtToken, User: user}, nil
}

// ForgotPassword provides ForgotPassword functionality.
func (uc *userUseCase) ForgotPassword(email string) error {
	user, err := uc.repo.GetUserByEmail(email)
	if err != nil || user == nil {
		return nil // Avoid leaking email existence
	}

	otp := generateOTP()
	otpHash, err := bcrypt.GenerateFromPassword([]byte(otp), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	token := &domain.VerificationToken{
		ID:        uuid.New().String(),
		UserID:    user.ID,
		TokenHash: string(otpHash),
		Type:      "PASSWORD_RESET",
		ExpiresAt: time.Now().Add(15 * time.Minute),
		CreatedAt: time.Now(),
	}

	if err := uc.repo.CreateVerificationToken(token); err != nil {
		return err
	}

	go uc.emailSvc.SendResetLink(user.Email, otp)

	return nil
}

// ResetPassword provides ResetPassword functionality.
func (uc *userUseCase) ResetPassword(email, otp, newPassword string) error {
	user, err := uc.repo.GetUserByEmail(email)
	if err != nil || user == nil {
		return ErrInvalidToken
	}

	tokens, err := uc.repo.GetVerificationTokensByUserID(user.ID, "PASSWORD_RESET")
	if err != nil {
		return err
	}

	var validToken *domain.VerificationToken
	for _, t := range tokens {
		if t.ExpiresAt.After(time.Now()) {
			if err := bcrypt.CompareHashAndPassword([]byte(t.TokenHash), []byte(otp)); err == nil {
				validToken = t
				break
			}
		}
	}

	if validToken == nil {
		return ErrInvalidToken
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(newPassword)); err == nil {
		return ErrSameAsOldPassword
	}

	hashed, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return err
	}

	user.PasswordHash = string(hashed)
	if err := uc.repo.UpdateUser(user); err != nil {
		return err
	}

	uc.repo.DeleteVerificationToken(validToken.ID)
	return nil
}
