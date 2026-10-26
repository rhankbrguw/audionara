package domain

import "time"

// User represents an authenticated user in the system.
type User struct {
	ID                string    `json:"id"`
	Username          string    `json:"username"`
	Email             string    `json:"email"`
	PasswordHash      string    `json:"-"`
	Bio               string    `json:"bio"`
	ProfilePictureUrl string    `json:"profilePictureUrl"`
	CreatedAt         time.Time `json:"createdAt"`
	IsEmailVerified   bool      `json:"isEmailVerified"`
}

// VerificationToken is used for email verification and password resets.
type VerificationToken struct {
	ID        string    `json:"id"`
	UserID    string    `json:"userId"`
	TokenHash string    `json:"-"`
	Type      string    `json:"type"` // "EMAIL_VERIFY" or "PASSWORD_RESET"
	ExpiresAt time.Time `json:"expiresAt"`
	CreatedAt time.Time `json:"createdAt"`
}

// AuthResponse wraps the user and their authentication token.
type AuthResponse struct {
	Token string `json:"token"`
	User  *User  `json:"user"`
}

// UserRepository defines the data access methods for users and tokens.
type UserRepository interface {
	CreateUser(user *User) error
	GetUserByEmail(email string) (*User, error)
	GetUserByID(id string) (*User, error)
	UpdateUser(user *User) error
	UpdateUserProfile(userID, bio, profilePictureUrl string) error
	UpdateUserProfileFull(userID, username, email, bio, profilePictureUrl string) error
	UpdateUserPassword(userID, newPasswordHash string) error

	CreateVerificationToken(token *VerificationToken) error
	GetVerificationTokensByUserID(userID string, tokenType string) ([]*VerificationToken, error)
	DeleteVerificationToken(id string) error
}

// UserUseCase defines the business logic for user authentication and management.
type UserUseCase interface {
	Register(username, email, password string) (*User, error)
	Login(email, password string) (*AuthResponse, error)
	GetProfile(userID string) (*User, error)
	UpdateProfile(userID, username, email, bio, profilePictureUrl string) error
	ChangePassword(userID, currentPassword, newPassword string) error

	VerifyEmail(email, otp string) (*AuthResponse, error)
	ForgotPassword(email string) error
	ResetPassword(email, otp, newPassword string) error
}
