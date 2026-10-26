package usecase

import (
	"errors"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/pkg/email"
	"github.com/user/audionara/backend/pkg/env"
	"golang.org/x/crypto/bcrypt"
)

var ErrInvalidCredentials = errors.New("invalid email or password")
var ErrUserExists = errors.New("user already exists")
var ErrEmailNotVerified = errors.New("email not verified")
var ErrInvalidToken = errors.New("invalid or expired token")
var ErrSameAsOldPassword = errors.New("new password cannot be the same as old password")

type userUseCase struct {
	repo     domain.UserRepository
	emailSvc email.EmailService
}

// NewUserUseCase creates and returns a new UserUseCase instance.
func NewUserUseCase(repo domain.UserRepository, emailSvc email.EmailService) domain.UserUseCase {
	return &userUseCase{repo: repo, emailSvc: emailSvc}
}

// GetProfile retrieves the Profile based on the provided parameters.
func (uc *userUseCase) GetProfile(userID string) (*domain.User, error) {
	return uc.repo.GetUserByID(userID)
}

// UpdateProfile updates an existing Profile.
func (uc *userUseCase) UpdateProfile(userID, username, email, bio, profilePictureUrl string) error {
	existing, err := uc.repo.GetUserByID(userID)
	if err != nil || existing == nil {
		return errors.New("user not found")
	}
	if username == "" {
		username = existing.Username
	}
	if email == "" {
		email = existing.Email
	}
	if email != existing.Email {
		if other, _ := uc.repo.GetUserByEmail(email); other != nil && other.ID != userID {
			return ErrUserExists
		}
	}
	return uc.repo.UpdateUserProfileFull(userID, username, email, bio, profilePictureUrl)
}

// ChangePassword changes the user's password after verifying current password.
func (uc *userUseCase) ChangePassword(userID, currentPassword, newPassword string) error {
	user, err := uc.repo.GetUserByID(userID)
	if err != nil || user == nil {
		return errors.New("user not found")
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(currentPassword)); err != nil {
		return ErrInvalidCredentials
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(newPassword)); err == nil {
		return ErrSameAsOldPassword
	}
	hashed, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	return uc.repo.UpdateUserPassword(userID, string(hashed))
}

func (uc *userUseCase) generateJWT(userID string) (string, error) {
	secret := env.GetWithDefault("JWT_SECRET", "super_secret_jwt_key")
	expiryHours := env.GetInt("JWT_EXPIRY_HOURS", 24)

	claims := jwt.MapClaims{
		"sub": userID,
		"exp": time.Now().Add(time.Duration(expiryHours) * time.Hour).Unix(),
		"iat": time.Now().Unix(),
	}

	t := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return t.SignedString([]byte(secret))
}
