package usecase_test

import (
	"testing"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/usecase"
	"golang.org/x/crypto/bcrypt"
)

type mockUserRepo struct {
	getUserByEmailFn func(email string) (*domain.User, error)
	getTokensFn      func(userID string, tokenType string) ([]*domain.VerificationToken, error)
	updateUserFn     func(user *domain.User) error
	deleteTokenFn    func(id string) error
	createTokenFn    func(token *domain.VerificationToken) error
}

func (m *mockUserRepo) CreateUser(user *domain.User) error { return nil }
func (m *mockUserRepo) GetUserByEmail(email string) (*domain.User, error) {
	if m.getUserByEmailFn != nil {
		return m.getUserByEmailFn(email)
	}
	return nil, nil
}
func (m *mockUserRepo) GetUserByID(id string) (*domain.User, error) { return nil, nil }
func (m *mockUserRepo) UpdateUser(user *domain.User) error {
	if m.updateUserFn != nil {
		return m.updateUserFn(user)
	}
	return nil
}
func (m *mockUserRepo) UpdateUserProfile(userID, bio, profilePictureUrl string) error { return nil }
func (m *mockUserRepo) UpdateUserProfileFull(userID, username, email, bio, profilePictureUrl string) error { return nil }
func (m *mockUserRepo) UpdateUserPassword(userID, newPasswordHash string) error { return nil }
func (m *mockUserRepo) CreateVerificationToken(token *domain.VerificationToken) error {
	if m.createTokenFn != nil {
		return m.createTokenFn(token)
	}
	return nil
}
func (m *mockUserRepo) GetVerificationTokensByUserID(userID string, tokenType string) ([]*domain.VerificationToken, error) {
	if m.getTokensFn != nil {
		return m.getTokensFn(userID, tokenType)
	}
	return nil, nil
}
func (m *mockUserRepo) DeleteVerificationToken(id string) error {
	if m.deleteTokenFn != nil {
		return m.deleteTokenFn(id)
	}
	return nil
}

type mockEmailSvc struct{}

func (m *mockEmailSvc) SendOTP(to string, otp string) error         { return nil }
func (m *mockEmailSvc) SendResetLink(to string, token string) error { return nil }

func TestUserUseCase_VerifyEmail(t *testing.T) {
	hashedOTP, _ := bcrypt.GenerateFromPassword([]byte("123456"), bcrypt.DefaultCost)

	tests := []struct {
		name    string
		email   string
		otp     string
		repo    *mockUserRepo
		wantErr bool
	}{
		{
			name:  "user not found",
			email: "notfound@test.com",
			otp:   "123456",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return nil, usecase.ErrInvalidCredentials
				},
			},
			wantErr: true,
		},
		{
			name:  "invalid otp",
			email: "found@test.com",
			otp:   "wrong",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return &domain.User{ID: "1"}, nil
				},
				getTokensFn: func(userID string, tokenType string) ([]*domain.VerificationToken, error) {
					return []*domain.VerificationToken{
						{ID: "1", UserID: "1", TokenHash: string(hashedOTP), ExpiresAt: time.Now().Add(1 * time.Hour)},
					}, nil
				},
			},
			wantErr: true,
		},
		{
			name:  "valid otp",
			email: "found@test.com",
			otp:   "123456",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return &domain.User{ID: "1"}, nil
				},
				getTokensFn: func(userID string, tokenType string) ([]*domain.VerificationToken, error) {
					return []*domain.VerificationToken{
						{ID: "1", UserID: "1", TokenHash: string(hashedOTP), ExpiresAt: time.Now().Add(1 * time.Hour)},
					}, nil
				},
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			uc := usecase.NewUserUseCase(tt.repo, &mockEmailSvc{})
			_, err := uc.VerifyEmail(tt.email, tt.otp)
			if tt.wantErr && err == nil {
				t.Errorf("expected error, got nil")
			}
			if !tt.wantErr && err != nil {
				t.Errorf("unexpected error: %v", err)
			}
		})
	}
}
