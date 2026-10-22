package repository

import (
	"context"
	"fmt"
	"net/url"
	"strings"
	"sync"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

// SearchMulti performs concurrent multi-entity search for songs, albums, and artists.
func (r *DeezerRepository) SearchMulti(ctx context.Context, query string, limit int, explicit bool) (*domain.SearchResult, error) {
	if limit <= 0 {
		limit = 20
	}
	cacheKey := fmt.Sprintf("search:multi:%s:%d:%t", query, limit, explicit)
	var cached domain.SearchResult
	if r.cacheRepo != nil && r.cacheRepo.GetJSON(ctx, cacheKey, &cached) == nil && len(cached.Songs) > 0 {
		return &cached, nil
	}

	result, err := r.executeConcurrentSearch(ctx, query, limit, explicit)
	if err != nil {
		return nil, err
	}

	if r.cacheRepo != nil {
		_ = r.cacheRepo.SetJSON(ctx, cacheKey, result, 30*time.Minute)
	}
	return result, nil
}

func (r *DeezerRepository) executeConcurrentSearch(ctx context.Context, query string, limit int, explicit bool) (*domain.SearchResult, error) {
	var wg sync.WaitGroup
	var songs, albums, artists []*domain.Track
	var songErr, albumErr, artistErr error

	wg.Add(3)
	go func() { defer wg.Done(); songs, songErr = r.searchTracks(ctx, query, limit, explicit) }()
	go func() { defer wg.Done(); albums, albumErr = r.searchAlbums(ctx, query, limit) }()
	go func() { defer wg.Done(); artists, artistErr = r.searchArtists(ctx, query, limit) }()
	wg.Wait()

	if songErr != nil && albumErr != nil && artistErr != nil {
		return nil, songErr
	}

	mergedArtists, mergedAlbums := mergeEntitiesFromTracks(songs, artists, albums)
	topResult := selectTopResult(query, songs, mergedArtists, mergedAlbums)

	return &domain.SearchResult{
		TopResult: topResult,
		Songs:     orEmptyTracks(songs),
		Albums:    orEmptyTracks(mergedAlbums),
		Artists:   orEmptyTracks(mergedArtists),
	}, nil
}

func (r *DeezerRepository) searchTracks(ctx context.Context, query string, limit int, explicit bool) ([]*domain.Track, error) {
	escaped := url.QueryEscape(query)
	endpoint := fmt.Sprintf("/search/track?q=%s&limit=%d", escaped, limit*2)
	var payload struct {
		Data []deezerTrackDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, endpoint, &payload); err != nil {
		return nil, err
	}
	return rankAndSortTracks(query, payload.Data, explicit), nil
}

func selectTopResult(query string, songs, artists, albums []*domain.Track) *domain.TopResultItem {
	q := strings.ToLower(strings.TrimSpace(query))
	if q == "" {
		return nil
	}
	var bestItem *domain.TopResultItem
	var bestScore float64

	if len(artists) > 0 {
		score := evaluateEntityMatch(q, strings.ToLower(artists[0].Title), 1300, 750, 350)
		if score > bestScore {
			bestScore = score
			bestItem = &domain.TopResultItem{
				Type: "artist", ID: artists[0].ID, Title: artists[0].Title,
				Subtitle: "Artist", CoverArt: artists[0].CoverArt, ArtistID: artists[0].ID,
			}
		}
	}
	if len(albums) > 0 {
		score := evaluateEntityMatch(q, strings.ToLower(albums[0].Title), 1100, 650, 300)
		if score > bestScore {
			bestScore = score
			bestItem = &domain.TopResultItem{
				Type: "album", ID: albums[0].ID, Title: albums[0].Title,
				Subtitle: albums[0].Artist, CoverArt: albums[0].CoverArt, AlbumID: albums[0].ID, Artist: albums[0].Artist,
			}
		}
	}
	if len(songs) > 0 {
		score := evaluateEntityMatch(q, strings.ToLower(songs[0].Title), 1000, 600, 250)
		if score > bestScore {
			bestScore = score
			bestItem = &domain.TopResultItem{
				Type: "song", ID: songs[0].ID, Title: songs[0].Title,
				Subtitle: songs[0].Artist, CoverArt: songs[0].CoverArt, Artist: songs[0].Artist,
				ArtistID: songs[0].ArtistID, AlbumID: songs[0].AlbumID, DurationMs: songs[0].DurationMs,
				IsExplicit: songs[0].IsExplicit,
			}
		}
	}
	if bestScore >= 200 {
		return bestItem
	}
	return nil
}

func evaluateEntityMatch(query, target string, exactWeight, prefixWeight, containsWeight float64) float64 {
	if target == query {
		return exactWeight
	}
	if strings.HasPrefix(target, query) {
		penalty := float64(len(target)-len(query)) * 2
		return prefixWeight - penalty
	}
	if strings.Contains(target, query) {
		penalty := float64(len(target) - len(query))
		return containsWeight - penalty
	}
	return 0
}

func orEmptyTracks(in []*domain.Track) []*domain.Track {
	if in == nil {
		return []*domain.Track{}
	}
	return in
}

