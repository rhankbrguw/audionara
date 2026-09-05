package repository

import (
	"context"
	"fmt"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

// GetAlbumDetail fetches album metadata and full tracklist from Deezer.
func (r *DeezerRepository) GetAlbumDetail(ctx context.Context, albumID string) (*domain.AlbumDetail, error) {
	if albumID == "" {
		return nil, fmt.Errorf("album id required")
	}

	cacheKey := "album:detail:" + albumID
	var cached domain.AlbumDetail
	if r.cacheRepo != nil && r.cacheRepo.GetJSON(ctx, cacheKey, &cached) == nil && cached.Meta != nil {
		return &cached, nil
	}

	detail, err := r.fetchAlbumDetail(ctx, albumID)
	if err != nil {
		return nil, err
	}

	if r.cacheRepo != nil {
		_ = r.cacheRepo.SetJSON(ctx, cacheKey, detail, 24*time.Hour)
	}
	return detail, nil
}

func mapAlbumTracks(dto deezerAlbumDTO) []*domain.Track {
	tracks := make([]*domain.Track, 0, len(dto.Tracks.Data))
	for idx, t := range dto.Tracks.Data {
		if t.Album.ID == 0 {
			t.Album.ID = dto.ID
			t.Album.Title = dto.Title
			t.Album.CoverXL = dto.CoverXL
			t.Album.CoverBig = dto.CoverBig
			t.Album.Cover = dto.Cover
		}
		if t.Artist.ID == 0 {
			t.Artist = dto.Artist
		}
		domainTrack := mapDeezerTrackToDomain(t)
		if domainTrack.TrackNumber == 0 {
			domainTrack.TrackNumber = idx + 1
		}
		tracks = append(tracks, domainTrack)
	}
	return tracks
}

func (r *DeezerRepository) fetchAlbumDetail(ctx context.Context, albumID string) (*domain.AlbumDetail, error) {
	var dto deezerAlbumDTO
	if err := r.fetchJSON(ctx, "/album/"+albumID, &dto); err != nil {
		return nil, fmt.Errorf("deezer album lookup: %w", err)
	}

	return &domain.AlbumDetail{
		Meta:   mapDeezerAlbumToMeta(dto),
		Tracks: mapAlbumTracks(dto),
	}, nil
}
