package repository

import (
	"database/sql"

	"github.com/user/audionara/backend/internal/domain"
)

type historyRepository struct {
	db *sql.DB
}

// NewHistoryRepository creates and returns a new HistoryRepository instance.
func NewHistoryRepository(db *sql.DB) domain.HistoryRepository {
	return &historyRepository{db: db}
}

// LogPlay provides LogPlay functionality.
func (r *historyRepository) LogPlay(record *domain.HistoryRecord) error {
	query := `
		INSERT INTO listening_history (device_id, track_id, title, artist, genre, duration_ms)
		VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err := r.db.Exec(query, record.DeviceID, record.TrackID, record.Title, record.Artist, record.Genre, record.DurationMs)
	return err
}

// GetRecentHistory retrieves the RecentHistory based on the provided parameters.
func (r *historyRepository) GetRecentHistory(deviceID string, limit int) ([]*domain.HistoryRecord, error) {
	query := `
		SELECT id, device_id, track_id, title, artist, genre, duration_ms, played_at
		FROM listening_history
		WHERE device_id = $1
		ORDER BY played_at DESC
		LIMIT $2
	`
	rows, err := r.db.Query(query, deviceID, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var history []*domain.HistoryRecord
	for rows.Next() {
		var h domain.HistoryRecord
		if err := rows.Scan(&h.ID, &h.DeviceID, &h.TrackID, &h.Title, &h.Artist, &h.Genre, &h.DurationMs, &h.PlayedAt); err != nil {
			return nil, err
		}
		history = append(history, &h)
	}
	return history, nil
}

// GetTopArtists retrieves the top played artists for a device ordered by play count.
func (r *historyRepository) GetTopArtists(deviceID string, limit int) ([]string, error) {
	if limit <= 0 {
		limit = 5
	}
	query := `
		SELECT artist
		FROM listening_history
		WHERE device_id = $1 AND artist != ''
		GROUP BY artist
		ORDER BY COUNT(*) DESC
		LIMIT $2
	`
	rows, err := r.db.Query(query, deviceID, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var artists []string
	for rows.Next() {
		var a string
		if err := rows.Scan(&a); err == nil && a != "" {
			artists = append(artists, a)
		}
	}
	return artists, nil
}
