package repository

import (
	"context"
	"fmt"
	"sort"
	"strconv"
	"sync"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

// GetArtistTopSongs fetches top songs for an artist from Deezer.
func (r *DeezerRepository) GetArtistTopSongs(ctx context.Context, artistID string, explicit bool) ([]*domain.Track, error) {
	if artistID == "" {
		return nil, fmt.Errorf("artist id required")
	}

	cacheKey := fmt.Sprintf("artist:top:%s:%t", artistID, explicit)
	var cached []*domain.Track
	if r.cacheRepo != nil && r.cacheRepo.GetJSON(ctx, cacheKey, &cached) == nil && len(cached) > 0 {
		return cached, nil
	}

	endpoint := fmt.Sprintf("/artist/%s/top?limit=30", artistID)
	var payload struct {
		Data []deezerTrackDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, endpoint, &payload); err != nil {
		return nil, fmt.Errorf("deezer artist top: %w", err)
	}

	tracks := make([]*domain.Track, 0, len(payload.Data))
	for _, dto := range payload.Data {
		if !explicit && dto.ExplicitLyrics {
			continue
		}
		tracks = append(tracks, mapDeezerTrackToDomain(dto))
	}

	if r.cacheRepo != nil && len(tracks) > 0 {
		_ = r.cacheRepo.SetJSON(ctx, cacheKey, tracks, 12*time.Hour)
	}
	return tracks, nil
}

// GetArtistDetail gathers complete artist information, top tracks, albums, and Wikipedia bio.
func (r *DeezerRepository) GetArtistDetail(ctx context.Context, artistID string) (*domain.ArtistDetail, error) {
	if artistID == "" {
		return nil, fmt.Errorf("artist id required")
	}

	cacheKey := "artist:detail:" + artistID
	var cached domain.ArtistDetail
	if r.cacheRepo != nil && r.cacheRepo.GetJSON(ctx, cacheKey, &cached) == nil && cached.Name != "" {
		return &cached, nil
	}

	detail, err := r.fetchFullArtistDetail(ctx, artistID)
	if err != nil {
		return nil, err
	}

	if r.cacheRepo != nil {
		_ = r.cacheRepo.SetJSON(ctx, cacheKey, detail, 24*time.Hour)
	}
	return detail, nil
}

func (r *DeezerRepository) fetchFullArtistDetail(ctx context.Context, artistID string) (*domain.ArtistDetail, error) {
	var artistDTO deezerArtistDTO
	if err := r.fetchJSON(ctx, "/artist/"+artistID, &artistDTO); err != nil {
		return nil, fmt.Errorf("deezer artist lookup: %w", err)
	}

	var wg sync.WaitGroup
	var topTracks []*domain.Track
	var albums []*domain.AlbumMeta
	var bio, history string

	wg.Add(3)
	go func() { defer wg.Done(); topTracks, _ = r.GetArtistTopSongs(ctx, artistID, true) }()
	go func() { defer wg.Done(); albums = r.fetchArtistAlbums(ctx, artistID, artistDTO.Name) }()
	go func() { defer wg.Done(); bio, history = r.fetchWikiSummary(ctx, artistDTO.Name) }()
	wg.Wait()

	picture := pickBestArtwork(artistDTO.PictureXL, artistDTO.PictureBig, artistDTO.PictureMedium, artistDTO.Picture)
	return &domain.ArtistDetail{
		ID:         strconv.FormatInt(artistDTO.ID, 10),
		Name:       artistDTO.Name,
		Picture:    picture,
		Bio:        bio,
		History:    history,
		FansCount:  artistDTO.NbFan,
		AlbumCount: artistDTO.NbAlbum,
		Genres:     []string{},
		TopTracks:  orEmptyTracks(topTracks),
		Albums:     albums,
	}, nil
}

func (r *DeezerRepository) fetchArtistAlbums(ctx context.Context, artistID, artistName string) []*domain.AlbumMeta {
	endpoint := fmt.Sprintf("/artist/%s/albums?limit=100", artistID)
	var payload struct {
		Data []deezerAlbumDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, endpoint, &payload); err != nil {
		return []*domain.AlbumMeta{}
	}

	result := make([]*domain.AlbumMeta, 0, len(payload.Data))
	for _, a := range payload.Data {
		if a.Artist.Name == "" {
			a.Artist.Name = artistName
		}
		result = append(result, mapDeezerAlbumToMeta(a))
	}
	sort.Slice(result, func(i, j int) bool {
		dI := result[i].ReleaseDate
		if dI == "" {
			dI = result[i].Year
		}
		dJ := result[j].ReleaseDate
		if dJ == "" {
			dJ = result[j].Year
		}
		return dI > dJ
	})
	return result
}
