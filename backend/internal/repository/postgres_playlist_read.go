package repository

import (
	"github.com/user/audionara/backend/internal/domain"
)

// IsTrackSaved provides IsTrackSaved functionality.
func (r *postgresPlaylistRepository) IsTrackSaved(userID string, trackID string) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM playlist_tracks WHERE user_id = $1 AND track_id = $2)`
	var exists bool
	err := r.db.QueryRow(query, userID, trackID).Scan(&exists)
	return exists, err
}

// GetSavedTracks retrieves the SavedTracks based on the provided parameters.
func (r *postgresPlaylistRepository) GetSavedTracks(userID string) ([]*domain.PlaylistTrack, error) {
	query := `
		SELECT track_id, user_id, title, artist, stream_url, cover_art, artist_id, album_id, duration_ms, added_at 
		FROM playlist_tracks 
		WHERE user_id = $1 
		ORDER BY added_at DESC
	`
	rows, err := r.db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tracks []*domain.PlaylistTrack
	for rows.Next() {
		var t domain.PlaylistTrack
		if err := rows.Scan(&t.TrackID, &t.UserID, &t.Title, &t.Artist, &t.StreamURL, &t.CoverArt, &t.ArtistID, &t.AlbumID, &t.DurationMs, &t.AddedAt); err != nil {
			return nil, err
		}
		tracks = append(tracks, &t)
	}
	if tracks == nil {
		tracks = make([]*domain.PlaylistTrack, 0)
	}
	return tracks, nil
}

// GetCustomPlaylists retrieves the CustomPlaylists based on the provided parameters.
func (r *postgresPlaylistRepository) GetCustomPlaylists(userID string) ([]*domain.CustomPlaylist, error) {
	query := `
		SELECT id, user_id, name, bio, cover_art_url, created_at
		FROM custom_playlists
		WHERE user_id = $1
		ORDER BY created_at DESC
	`
	rows, err := r.db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var playlists []*domain.CustomPlaylist
	for rows.Next() {
		var p domain.CustomPlaylist
		if err := rows.Scan(&p.ID, &p.UserID, &p.Name, &p.Bio, &p.CoverArtURL, &p.CreatedAt); err != nil {
			return nil, err
		}
		playlists = append(playlists, &p)
	}
	if playlists == nil {
		playlists = make([]*domain.CustomPlaylist, 0)
	}
	return playlists, nil
}

// GetCustomPlaylistTracks retrieves the CustomPlaylistTracks based on the provided parameters.
func (r *postgresPlaylistRepository) GetCustomPlaylistTracks(playlistID string) ([]*domain.CustomPlaylistTrack, error) {
	query := `
		SELECT id, playlist_id, track_id, title, artist, stream_url, cover_art, artist_id, album_id, duration_ms, added_at
		FROM custom_playlist_tracks
		WHERE playlist_id = $1
		ORDER BY added_at ASC
	`
	rows, err := r.db.Query(query, playlistID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var tracks []*domain.CustomPlaylistTrack
	for rows.Next() {
		var t domain.CustomPlaylistTrack
		if err := rows.Scan(&t.ID, &t.PlaylistID, &t.TrackID, &t.Title, &t.Artist, &t.StreamURL, &t.CoverArt, &t.ArtistID, &t.AlbumID, &t.DurationMs, &t.AddedAt); err != nil {
			return nil, err
		}
		tracks = append(tracks, &t)
	}
	if tracks == nil {
		tracks = make([]*domain.CustomPlaylistTrack, 0)
	}
	return tracks, nil
}
