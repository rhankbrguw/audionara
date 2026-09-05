package usecase_test

import (
	"testing"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/usecase"
)

func TestUserUseCase_ForgotPassword(t *testing.T) {
	tests := []struct {
		name    string
		email   string
		repo    *mockUserRepo
		wantErr bool
	}{
		{
			name:  "user not found does not error",
			email: "notfound@test.com",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return nil, usecase.ErrInvalidCredentials
				},
			},
			wantErr: false,
		},
		{
			name:  "valid user creates token",
			email: "found@test.com",
			repo: &mockUserRepo{
				getUserByEmailFn: func(email string) (*domain.User, error) {
					return &domain.User{ID: "1"}, nil
				},
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			uc := usecase.NewUserUseCase(tt.repo, &mockEmailSvc{})
			err := uc.ForgotPassword(tt.email)
			if tt.wantErr && err == nil {
				t.Errorf("expected error, got nil")
			}
			if !tt.wantErr && err != nil {
				t.Errorf("unexpected error: %v", err)
			}
		})
	}
}
