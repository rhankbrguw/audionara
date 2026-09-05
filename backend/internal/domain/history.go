package domain

import "time"

// HistoryRecord represents a single entry in a user's listening history.
type HistoryRecord struct {
	ID         int       `json:"id"`
	DeviceID   string    `json:"device_id"`
	TrackID    string    `json:"track_id"`
	Title      string    `json:"title"`
	Artist     string    `json:"artist"`
	Genre      string    `json:"genre"`
	DurationMs int       `json:"duration_ms"`
	PlayedAt   time.Time `json:"played_at"`
}

// HistoryRepository provides access to the listening history.
type HistoryRepository interface {
	LogPlay(record *HistoryRecord) error
	GetRecentHistory(deviceID string, limit int) ([]*HistoryRecord, error)
	GetTopArtists(deviceID string, limit int) ([]string, error)
}
