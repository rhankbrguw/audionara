package usecase_test

import (
	"errors"
	"testing"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/usecase"
	"golang.org/x/crypto/bcrypt"
)

func TestUserUseCase_ResetPassword(t *testing.T) {
	oldPassHash, _ := bcrypt.GenerateFromPassword([]byte("OldPass123!"), bcrypt.DefaultCost)
	otpHash, _ := bcrypt.GenerateFromPassword([]byte("123456"), bcrypt.DefaultCost)

	tests := []struct {
		name        string
		email       string
		otp         string
		newPassword string
		repo        *mockUserRepo
		expectedErr error
	}{
		{
			name:        "user not found",
			email:       "notfound@test.com",
			otp:         "123456",
			newPassword: "NewPass123!",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return nil, errors.New("not found")
				},
			},
			expectedErr: usecase.ErrInvalidToken,
		},
		{
			name:        "same as old password rejected",
			email:       "user@test.com",
			otp:         "123456",
			newPassword: "OldPass123!",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return &domain.User{ID: "1", PasswordHash: string(oldPassHash)}, nil
				},
				getTokensFn: func(userID string, tokenType string) ([]*domain.VerificationToken, error) {
					return []*domain.VerificationToken{
						{ID: "tok-1", UserID: "1", TokenHash: string(otpHash), ExpiresAt: time.Now().Add(10 * time.Minute)},
					}, nil
				},
			},
			expectedErr: usecase.ErrSameAsOldPassword,
		},
		{
			name:        "valid new password succeeds",
			email:       "user@test.com",
			otp:         "123456",
			newPassword: "NewDifferentPass123!",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return &domain.User{ID: "1", PasswordHash: string(oldPassHash)}, nil
				},
				getTokensFn: func(userID string, tokenType string) ([]*domain.VerificationToken, error) {
					return []*domain.VerificationToken{
						{ID: "tok-1", UserID: "1", TokenHash: string(otpHash), ExpiresAt: time.Now().Add(10 * time.Minute)},
					}, nil
				},
				updateUserFn: func(user *domain.User) error {
					return nil
				},
				deleteTokenFn: func(id string) error {
					return nil
				},
			},
			expectedErr: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			uc := usecase.NewUserUseCase(tt.repo, &mockEmailSvc{})
			err := uc.ResetPassword(tt.email, tt.otp, tt.newPassword)
			if tt.expectedErr != nil {
				if !errors.Is(err, tt.expectedErr) {
					t.Errorf("expected %v, got %v", tt.expectedErr, err)
				}
			} else if err != nil {
				t.Errorf("unexpected error: %v", err)
			}
		})
	}
}
