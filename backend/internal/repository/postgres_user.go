package repository

import (
	"database/sql"
	"errors"

	"github.com/user/audionara/backend/internal/domain"
)

type postgresUserRepository struct {
	db *sql.DB
}

// NewPostgresUserRepository creates and returns a new PostgresUserRepository instance.
func NewPostgresUserRepository(db *sql.DB) domain.UserRepository {
	return &postgresUserRepository{db: db}
}

// CreateUser creates a new User.
func (r *postgresUserRepository) CreateUser(user *domain.User) error {
	query := `
		INSERT INTO users (id, username, email, password_hash, created_at, is_email_verified)
		VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err := r.db.Exec(query, user.ID, user.Username, user.Email, user.PasswordHash, user.CreatedAt, user.IsEmailVerified)
	return err
}

// GetUserByEmail retrieves the UserByEmail based on the provided parameters.
func (r *postgresUserRepository) GetUserByEmail(email string) (*domain.User, error) {
	query := `SELECT id, username, email, password_hash, bio, profile_picture_url, created_at, is_email_verified FROM users WHERE email = $1`
	var u domain.User
	err := r.db.QueryRow(query, email).Scan(&u.ID, &u.Username, &u.Email, &u.PasswordHash, &u.Bio, &u.ProfilePictureUrl, &u.CreatedAt, &u.IsEmailVerified)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil // Not found
		}
		return nil, err
	}
	return &u, nil
}

// GetUserByID retrieves the UserByID based on the provided parameters.
func (r *postgresUserRepository) GetUserByID(id string) (*domain.User, error) {
	query := `SELECT id, username, email, password_hash, bio, profile_picture_url, created_at, is_email_verified FROM users WHERE id = $1`
	var u domain.User
	err := r.db.QueryRow(query, id).Scan(&u.ID, &u.Username, &u.Email, &u.PasswordHash, &u.Bio, &u.ProfilePictureUrl, &u.CreatedAt, &u.IsEmailVerified)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil // Not found
		}
		return nil, err
	}
	return &u, nil
}

// UpdateUser updates an existing User.
func (r *postgresUserRepository) UpdateUser(user *domain.User) error {
	query := `
		UPDATE users 
		SET username = $1, email = $2, password_hash = $3, is_email_verified = $4
		WHERE id = $5
	`
	_, err := r.db.Exec(query, user.Username, user.Email, user.PasswordHash, user.IsEmailVerified, user.ID)
	return err
}

// UpdateUserProfile updates an existing UserProfile.
func (r *postgresUserRepository) UpdateUserProfile(userID, bio, profilePictureUrl string) error {
	query := `UPDATE users SET bio = $1, profile_picture_url = $2 WHERE id = $3`
	_, err := r.db.Exec(query, bio, profilePictureUrl, userID)
	return err
}

// UpdateUserProfileFull updates username, email, bio, and profile picture.
func (r *postgresUserRepository) UpdateUserProfileFull(userID, username, email, bio, profilePictureUrl string) error {
	query := `UPDATE users SET username = $1, email = $2, bio = $3, profile_picture_url = $4 WHERE id = $5`
	_, err := r.db.Exec(query, username, email, bio, profilePictureUrl, userID)
	return err
}

// UpdateUserPassword updates the password hash for a user.
func (r *postgresUserRepository) UpdateUserPassword(userID, newPasswordHash string) error {
	query := `UPDATE users SET password_hash = $1 WHERE id = $2`
	_, err := r.db.Exec(query, newPasswordHash, userID)
	return err
}

// CreateVerificationToken creates a new VerificationToken.
func (r *postgresUserRepository) CreateVerificationToken(token *domain.VerificationToken) error {
	query := `
		INSERT INTO verification_tokens (id, user_id, token_hash, type, expires_at, created_at)
		VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err := r.db.Exec(query, token.ID, token.UserID, token.TokenHash, token.Type, token.ExpiresAt, token.CreatedAt)
	return err
}

// GetVerificationTokensByUserID retrieves the VerificationTokensByUserID based on the provided parameters.
func (r *postgresUserRepository) GetVerificationTokensByUserID(userID string, tokenType string) ([]*domain.VerificationToken, error) {
	query := `
		SELECT id, user_id, token_hash, type, expires_at, created_at 
		FROM verification_tokens 
		WHERE user_id = $1 AND type = $2
	`
	rows, err := r.db.Query(query, userID, tokenType)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tokens []*domain.VerificationToken
	for rows.Next() {
		var t domain.VerificationToken
		if err := rows.Scan(&t.ID, &t.UserID, &t.TokenHash, &t.Type, &t.ExpiresAt, &t.CreatedAt); err != nil {
			return nil, err
		}
		tokens = append(tokens, &t)
	}
	return tokens, nil
}

// DeleteVerificationToken deletes the specified VerificationToken.
func (r *postgresUserRepository) DeleteVerificationToken(id string) error {
	query := `DELETE FROM verification_tokens WHERE id = $1`
	_, err := r.db.Exec(query, id)
	return err
}
