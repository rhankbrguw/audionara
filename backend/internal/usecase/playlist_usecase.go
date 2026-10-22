package usecase

import (
	"time"

	"github.com/google/uuid"
	"github.com/user/audionara/backend/internal/domain"
)

type playlistUseCase struct {
	repo domain.PlaylistRepository
}

// NewPlaylistUseCase creates and returns a new PlaylistUseCase instance.
func NewPlaylistUseCase(repo domain.PlaylistRepository) domain.PlaylistUseCase {
	return &playlistUseCase{repo: repo}
}

// ToggleTrack provides ToggleTrack functionality.
func (uc *playlistUseCase) ToggleTrack(track *domain.PlaylistTrack) (bool, error) {
	isSaved, err := uc.repo.IsTrackSaved(track.UserID, track.TrackID)
	if err != nil {
		return false, err
	}

	if isSaved {
		err = uc.repo.RemoveTrack(track.UserID, track.TrackID)
		return false, err
	}

	err = uc.repo.AddTrack(track)
	return true, err
}

// IsTrackSaved provides IsTrackSaved functionality.
func (uc *playlistUseCase) IsTrackSaved(userID string, trackID string) (bool, error) {
	return uc.repo.IsTrackSaved(userID, trackID)
}

// GetSavedTracks retrieves the SavedTracks based on the provided parameters.
func (uc *playlistUseCase) GetSavedTracks(userID string) ([]*domain.PlaylistTrack, error) {
	return uc.repo.GetSavedTracks(userID)
}

// CreateCustomPlaylist creates a new CustomPlaylist.
func (uc *playlistUseCase) CreateCustomPlaylist(userID string, name string, bio string, coverArtURL string) (*domain.CustomPlaylist, error) {
	playlist := &domain.CustomPlaylist{
		ID:          uuid.New().String(),
		UserID:      userID,
		Name:        name,
		Bio:         bio,
		CoverArtURL: coverArtURL,
		CreatedAt:   time.Now(),
	}
	err := uc.repo.CreateCustomPlaylist(playlist)
	if err != nil {
		return nil, err
	}
	return playlist, nil
}

// GetCustomPlaylists retrieves the CustomPlaylists based on the provided parameters.
func (uc *playlistUseCase) GetCustomPlaylists(userID string) ([]*domain.CustomPlaylist, error) {
	return uc.repo.GetCustomPlaylists(userID)
}

// UpdateCustomPlaylist updates an existing CustomPlaylist.
func (uc *playlistUseCase) UpdateCustomPlaylist(userID string, playlistID string, name string, bio string, coverArtURL string) (*domain.CustomPlaylist, error) {
	playlist := &domain.CustomPlaylist{
		ID:          playlistID,
		UserID:      userID,
		Name:        name,
		Bio:         bio,
		CoverArtURL: coverArtURL,
	}
	err := uc.repo.UpdateCustomPlaylist(playlist)
	if err != nil {
		return nil, err
	}
	return playlist, nil
}

// DeleteCustomPlaylist deletes the specified CustomPlaylist.
func (uc *playlistUseCase) DeleteCustomPlaylist(userID string, playlistID string) error {
	return uc.repo.DeleteCustomPlaylist(userID, playlistID)
}

// AddTrackToCustomPlaylist provides AddTrackToCustomPlaylist functionality.
func (uc *playlistUseCase) AddTrackToCustomPlaylist(userID string, playlistID string, track *domain.CustomPlaylistTrack) error {
	track.ID = uuid.New().String()
	track.PlaylistID = playlistID
	track.AddedAt = time.Now()
	return uc.repo.AddTrackToCustomPlaylist(track)
}

// RemoveTrackFromCustomPlaylist provides RemoveTrackFromCustomPlaylist functionality.
func (uc *playlistUseCase) RemoveTrackFromCustomPlaylist(userID string, playlistID string, trackID string) error {
	// We might want to verify that the playlist belongs to the user, but for now we trust the handler
	return uc.repo.RemoveTrackFromCustomPlaylist(playlistID, trackID)
}

// GetCustomPlaylistTracks retrieves the CustomPlaylistTracks based on the provided parameters.
func (uc *playlistUseCase) GetCustomPlaylistTracks(userID string, playlistID string) ([]*domain.CustomPlaylistTrack, error) {
	return uc.repo.GetCustomPlaylistTracks(playlistID)
}
