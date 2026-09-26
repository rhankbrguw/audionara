package repository

import (
	"database/sql"
	"github.com/user/audionara/backend/internal/domain"
)

type postgresPlaylistRepository struct {
	db *sql.DB
}

// NewPostgresPlaylistRepository creates and returns a new PostgresPlaylistRepository instance.
func NewPostgresPlaylistRepository(db *sql.DB) domain.PlaylistRepository {
	return &postgresPlaylistRepository{db: db}
}
