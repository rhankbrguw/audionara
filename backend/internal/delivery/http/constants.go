package http

const (
	ErrMissingArtistID       = "Artist ID is required."
	ErrAlbumNotFound         = "Album not found."
	ErrArtistNotFound        = "Artist not found or has no tracks."
	ErrMissingArtistAndTitle = "artist and title are required"
	ErrLyricsNotFound        = "Lyrics not found."
	ErrMissingDeviceID       = "Device-Id header is required"
	ErrInvalidPayload        = "Invalid request payload"
	ErrSearchVibeEmpty       = "Search vibe cannot be empty"
	ErrSearchQueryRequired   = "Search query is required"
	ErrMissingTrackID        = "Track ID is required"
	ErrMissingAuthHeader     = "Missing authorization header"
	ErrInvalidAuthFormat     = "Invalid authorization header format"
	ErrInvalidOrExpiredToken = "Invalid or expired token"
	ErrInvalidTokenClaims    = "Invalid token claims"
	ErrInvalidUserIDInToken  = "Invalid user ID in token"
	ErrFailedToFetchStream   = "Failed to fetch stream URL"
	ErrFailedToFetchLyrics   = "Failed to fetch lyrics: "
)
