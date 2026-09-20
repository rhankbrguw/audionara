package domain

import (
	"context"
	"errors"
)

// ErrNotSupported signals that an operation is valid in the domain
// but has no concrete implementation for this repository backend.
var ErrNotSupported = errors.New("operation not supported by this repository")

// Track is the canonical audio entity. All upstream SDKs
// map into this struct.
type Track struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Artist      string `json:"artist"`
	StreamURL   string `json:"stream_url"`
	CoverArt    string `json:"cover_art"`
	DurationMs  int    `json:"duration_ms,omitempty"`
	TrackNumber int    `json:"track_number,omitempty"`
	AlbumID     string `json:"album_id,omitempty"`
	ArtistID    string `json:"artist_id,omitempty"`
	IsExplicit  bool   `json:"is_explicit,omitempty"`
}

// AlbumMeta holds collection-level metadata for an album.
type AlbumMeta struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Artist      string `json:"artist"`
	ArtistID    string `json:"artist_id,omitempty"`
	CoverArt    string `json:"cover_art"`
	Genre       string `json:"genre"`
	Year        string `json:"year"`
	TrackCount  int    `json:"track_count"`
	Copyright   string `json:"copyright"`
	Label       string `json:"label,omitempty"`
	ReleaseDate string `json:"release_date,omitempty"`
	RecordType  string `json:"record_type,omitempty"`
}

// AlbumDetail holds an album and its tracks.
type AlbumDetail struct {
	Meta   *AlbumMeta `json:"meta"`
	Tracks []*Track   `json:"tracks"`
}

// TrackRepository defines the interface for track operations.
type TrackRepository interface {
	SearchByVibe(ctx context.Context, vibe string, limit, offset int, explicit bool) ([]*Track, error)
	FindByID(ctx context.Context, id string) (*Track, error)
	FindAll(ctx context.Context) ([]*Track, error)
	Save(ctx context.Context, track *Track) error
	Delete(ctx context.Context, id string) error
	GetAlbumDetail(ctx context.Context, albumID string) (*AlbumDetail, error)
	GetArtistTopSongs(ctx context.Context, artistID string, explicit bool) ([]*Track, error)
	GetArtistDetail(ctx context.Context, artistID string) (*ArtistDetail, error)
}

