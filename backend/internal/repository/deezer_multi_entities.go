package repository

import (
	"context"
	"fmt"
	"net/url"
	"strconv"

	"github.com/user/audionara/backend/internal/domain"
)

func (r *DeezerRepository) searchAlbums(ctx context.Context, query string, limit int) ([]*domain.Track, error) {
	escaped := url.QueryEscape(query)
	endpoint := fmt.Sprintf("/search/album?q=%s&limit=%d", escaped, limit)
	var payload struct {
		Data []deezerAlbumDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, endpoint, &payload); err != nil {
		return nil, err
	}
	tracks := make([]*domain.Track, 0, len(payload.Data))
	for _, a := range payload.Data {
		meta := mapDeezerAlbumToMeta(a)
		tracks = append(tracks, &domain.Track{
			ID:       meta.ID,
			Title:    meta.Title,
			Artist:   meta.Artist,
			CoverArt: meta.CoverArt,
			AlbumID:  meta.ID,
		})
	}
	return tracks, nil
}

func (r *DeezerRepository) searchArtists(ctx context.Context, query string, limit int) ([]*domain.Track, error) {
	escaped := url.QueryEscape(query)
	endpoint := fmt.Sprintf("/search/artist?q=%s&limit=%d", escaped, limit)
	var payload struct {
		Data []deezerArtistDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, endpoint, &payload); err != nil {
		return nil, err
	}
	artists := make([]*domain.Track, 0, len(payload.Data))
	for _, a := range payload.Data {
		pic := pickBestArtwork(a.PictureXL, a.PictureBig, a.PictureMedium, a.Picture)
		artists = append(artists, &domain.Track{
			ID:       strconv.FormatInt(a.ID, 10),
			Title:    a.Name,
			Artist:   a.Name,
			CoverArt: pic,
			ArtistID: strconv.FormatInt(a.ID, 10),
		})
	}
	return artists, nil
}

func mergeEntitiesFromTracks(songs, artists, albums []*domain.Track) ([]*domain.Track, []*domain.Track) {
	seenArtists := make(map[string]bool)
	seenAlbums := make(map[string]bool)
	var finalArtists []*domain.Track
	var finalAlbums []*domain.Track

	for _, a := range artists {
		if !seenArtists[a.Artist] && a.Artist != "" {
			seenArtists[a.Artist] = true
			finalArtists = append(finalArtists, a)
		}
	}
	for _, alb := range albums {
		if !seenAlbums[alb.Title] && alb.Title != "" {
			seenAlbums[alb.Title] = true
			finalAlbums = append(finalAlbums, alb)
		}
	}
	for _, s := range songs {
		if s.Artist != "" && !seenArtists[s.Artist] {
			seenArtists[s.Artist] = true
			finalArtists = append(finalArtists, &domain.Track{
				ID: s.ArtistID, Title: s.Artist, Artist: s.Artist, CoverArt: s.CoverArt, ArtistID: s.ArtistID,
			})
		}
	}
	return finalArtists, finalAlbums
}
