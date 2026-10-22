package usecase

import (
	"crypto/rand"
	"time"

	"github.com/google/uuid"
	"github.com/user/audionara/backend/internal/domain"
	"golang.org/x/crypto/bcrypt"
)

func generateOTP() string {
	const charset = "0123456789"
	b := make([]byte, 6)
	rand.Read(b)
	for i := range b {
		b[i] = charset[int(b[i])%len(charset)]
	}
	return string(b)
}

// Register provides Register functionality.
func (uc *userUseCase) Register(username, email, password string) (*domain.User, error) {
	existing, _ := uc.repo.GetUserByEmail(email)
	if existing != nil {
		return nil, ErrUserExists
	}

	hashed, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	user := &domain.User{
		ID:              uuid.New().String(),
		Username:        username,
		Email:           email,
		PasswordHash:    string(hashed),
		CreatedAt:       time.Now(),
		IsEmailVerified: false,
	}

	if err := uc.repo.CreateUser(user); err != nil {
		return nil, err
	}

	// Generate and send OTP
	otp := generateOTP()
	otpHash, err := bcrypt.GenerateFromPassword([]byte(otp), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	token := &domain.VerificationToken{
		ID:        uuid.New().String(),
		UserID:    user.ID,
		TokenHash: string(otpHash),
		Type:      "EMAIL_VERIFY",
		ExpiresAt: time.Now().Add(15 * time.Minute),
		CreatedAt: time.Now(),
	}

	if err := uc.repo.CreateVerificationToken(token); err != nil {
		return nil, err
	}

	go uc.emailSvc.SendOTP(user.Email, otp)

	return user, nil
}

// Login provides Login functionality.
func (uc *userUseCase) Login(email, password string) (*domain.AuthResponse, error) {
	user, err := uc.repo.GetUserByEmail(email)
	if err != nil || user == nil {
		return nil, ErrInvalidCredentials
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return nil, ErrInvalidCredentials
	}

	if !user.IsEmailVerified {
		return nil, ErrEmailNotVerified
	}

	token, err := uc.generateJWT(user.ID)
	if err != nil {
		return nil, err
	}

	return &domain.AuthResponse{Token: token, User: user}, nil
}
