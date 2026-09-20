package domain

import "time"

// PlaylistTrack represents a track saved in a user's default playlist/library.
type PlaylistTrack struct {
	TrackID    string    `json:"trackId"`
	UserID     string    `json:"userId"`
	Title      string    `json:"title"`
	Artist     string    `json:"artist"`
	StreamURL  string    `json:"streamUrl"`
	CoverArt   string    `json:"coverArt"`
	ArtistID   string    `json:"artistId"`
	AlbumID    string    `json:"albumId"`
	DurationMs int       `json:"durationMs"`
	AddedAt    time.Time `json:"addedAt"`
}

// CustomPlaylist represents a user-created custom playlist.
type CustomPlaylist struct {
	ID          string    `json:"id"`
	UserID      string    `json:"userId"`
	Name        string    `json:"name"`
	Bio         string    `json:"bio"`
	CoverArtURL string    `json:"coverArtUrl"`
	CreatedAt   time.Time `json:"createdAt"`
}

// CustomPlaylistTrack represents a track within a custom playlist.
type CustomPlaylistTrack struct {
	ID         string    `json:"id"`
	PlaylistID string    `json:"playlistId"`
	TrackID    string    `json:"trackId"`
	Title      string    `json:"title"`
	Artist     string    `json:"artist"`
	StreamURL  string    `json:"streamUrl"`
	CoverArt   string    `json:"coverArt"`
	ArtistID   string    `json:"artistId"`
	AlbumID    string    `json:"albumId"`
	DurationMs int       `json:"durationMs"`
	AddedAt    time.Time `json:"addedAt"`
}

// PlaylistRepository defines the data access methods for managing playlists.
type PlaylistRepository interface {
	AddTrack(track *PlaylistTrack) error
	RemoveTrack(userID string, trackID string) error
	IsTrackSaved(userID string, trackID string) (bool, error)
	GetSavedTracks(userID string) ([]*PlaylistTrack, error)

	CreateCustomPlaylist(playlist *CustomPlaylist) error
	GetCustomPlaylists(userID string) ([]*CustomPlaylist, error)
	UpdateCustomPlaylist(playlist *CustomPlaylist) error
	DeleteCustomPlaylist(userID string, playlistID string) error
	AddTrackToCustomPlaylist(track *CustomPlaylistTrack) error
	RemoveTrackFromCustomPlaylist(playlistID string, trackID string) error
	GetCustomPlaylistTracks(playlistID string) ([]*CustomPlaylistTrack, error)
}

// PlaylistUseCase defines the business logic methods for managing playlists.
type PlaylistUseCase interface {
	ToggleTrack(track *PlaylistTrack) (bool, error)
	IsTrackSaved(userID string, trackID string) (bool, error)
	GetSavedTracks(userID string) ([]*PlaylistTrack, error)

	CreateCustomPlaylist(userID string, name string, bio string, coverArtURL string) (*CustomPlaylist, error)
	GetCustomPlaylists(userID string) ([]*CustomPlaylist, error)
	UpdateCustomPlaylist(userID string, playlistID string, name string, bio string, coverArtURL string) (*CustomPlaylist, error)
	DeleteCustomPlaylist(userID string, playlistID string) error
	AddTrackToCustomPlaylist(userID string, playlistID string, track *CustomPlaylistTrack) error
	RemoveTrackFromCustomPlaylist(userID string, playlistID string, trackID string) error
	GetCustomPlaylistTracks(userID string, playlistID string) ([]*CustomPlaylistTrack, error)
}
