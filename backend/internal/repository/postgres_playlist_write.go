package repository

import (
	"github.com/user/audionara/backend/internal/domain"
)

// AddTrack provides AddTrack functionality.
func (r *postgresPlaylistRepository) AddTrack(track *domain.PlaylistTrack) error {
	query := `
		INSERT INTO playlist_tracks (track_id, user_id, title, artist, stream_url, cover_art, artist_id, album_id, duration_ms, added_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
		ON CONFLICT (user_id, track_id) DO NOTHING
	`
	_, err := r.db.Exec(query, track.TrackID, track.UserID, track.Title, track.Artist, track.StreamURL, track.CoverArt, track.ArtistID, track.AlbumID, track.DurationMs, track.AddedAt)
	return err
}

// RemoveTrack provides RemoveTrack functionality.
func (r *postgresPlaylistRepository) RemoveTrack(userID string, trackID string) error {
	query := `DELETE FROM playlist_tracks WHERE user_id = $1 AND track_id = $2`
	_, err := r.db.Exec(query, userID, trackID)
	return err
}

// CreateCustomPlaylist creates a new CustomPlaylist.
func (r *postgresPlaylistRepository) CreateCustomPlaylist(playlist *domain.CustomPlaylist) error {
	query := `
		INSERT INTO custom_playlists (id, user_id, name, bio, cover_art_url, created_at)
		VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err := r.db.Exec(query, playlist.ID, playlist.UserID, playlist.Name, playlist.Bio, playlist.CoverArtURL, playlist.CreatedAt)
	return err
}

// UpdateCustomPlaylist updates an existing CustomPlaylist.
func (r *postgresPlaylistRepository) UpdateCustomPlaylist(playlist *domain.CustomPlaylist) error {
	query := `
		UPDATE custom_playlists
		SET name = $1, bio = $2, cover_art_url = $3
		WHERE id = $4 AND user_id = $5
	`
	_, err := r.db.Exec(query, playlist.Name, playlist.Bio, playlist.CoverArtURL, playlist.ID, playlist.UserID)
	return err
}

// DeleteCustomPlaylist deletes the specified CustomPlaylist.
func (r *postgresPlaylistRepository) DeleteCustomPlaylist(userID string, playlistID string) error {
	query := `DELETE FROM custom_playlists WHERE id = $1 AND user_id = $2`
	_, err := r.db.Exec(query, playlistID, userID)
	return err
}

// AddTrackToCustomPlaylist provides AddTrackToCustomPlaylist functionality.
func (r *postgresPlaylistRepository) AddTrackToCustomPlaylist(track *domain.CustomPlaylistTrack) error {
	query := `
		INSERT INTO custom_playlist_tracks (id, playlist_id, track_id, title, artist, stream_url, cover_art, artist_id, album_id, duration_ms, added_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
		ON CONFLICT (playlist_id, track_id) DO NOTHING
	`
	_, err := r.db.Exec(query, track.ID, track.PlaylistID, track.TrackID, track.Title, track.Artist, track.StreamURL, track.CoverArt, track.ArtistID, track.AlbumID, track.DurationMs, track.AddedAt)
	return err
}

// RemoveTrackFromCustomPlaylist provides RemoveTrackFromCustomPlaylist functionality.
func (r *postgresPlaylistRepository) RemoveTrackFromCustomPlaylist(playlistID string, trackID string) error {
	query := `DELETE FROM custom_playlist_tracks WHERE playlist_id = $1 AND track_id = $2`
	_, err := r.db.Exec(query, playlistID, trackID)
	return err
}
