package usecase

import (
	"context"
	"strings"

	"github.com/user/audionara/backend/internal/domain"
)

func deduplicateTracks(tracks []*domain.Track) []*domain.Track {
	seenIDs := make(map[string]struct{}, len(tracks))
	seenNames := make(map[string]struct{}, len(tracks))
	result := make([]*domain.Track, 0, len(tracks))

	for _, t := range tracks {
		if t == nil {
			continue
		}
		if t.ID != "" {
			if _, exists := seenIDs[t.ID]; exists {
				continue
			}
			seenIDs[t.ID] = struct{}{}
		}
		cleanTitle := strings.ToLower(normalizeTrackTitle(t.Title))
		cleanArtist := strings.ToLower(strings.TrimSpace(t.Artist))
		normKey := cleanTitle + ":" + cleanArtist
		if normKey != ":" {
			if _, exists := seenNames[normKey]; exists {
				continue
			}
			seenNames[normKey] = struct{}{}
		}
		result = append(result, t)
	}
	return result
}

func isChartQuery(vibe string) bool {
	norm := strings.ToLower(strings.TrimSpace(vibe))
	return strings.Contains(norm, "global top") || strings.Contains(norm, "viral") || norm == "chart" || norm == "charts" || strings.Contains(norm, "top 50") || strings.Contains(norm, "new release")
}

// SearchByVibe validates the input and delegates to the repository.
func (uc *TrackUseCase) SearchByVibe(ctx context.Context, vibe string, limit, offset int, explicit bool, quality int) ([]*domain.Track, error) {
	if vibe == "" {
		return nil, ErrEmptyVibe
	}
	if limit <= 0 {
		limit = 20
	}

	if isChartQuery(vibe) {
		tracks, err := uc.repo.SearchByVibe(ctx, vibe, limit, offset, explicit)
		if err != nil {
			return nil, err
		}
		tracks = deduplicateTracks(tracks)
		tracks = overrideURLs(tracks)
		uc.PreFetchStreamURLs(tracks, 3, explicit, quality)
		return tracks, nil
	}

	primaryLimit := int(float64(limit) * 0.7)
	secondaryLimit := limit - primaryLimit
	primaryOffset := int(float64(offset) * 0.7)
	secondaryOffset := offset - primaryOffset
	relatedVibe := getRelatedVibe(vibe)

	pTracks, pErr := uc.repo.SearchByVibe(ctx, vibe, primaryLimit, primaryOffset, explicit)
	if pErr != nil {
		return nil, pErr
	}
	sTracks, _ := uc.repo.SearchByVibe(ctx, relatedVibe, secondaryLimit, secondaryOffset, explicit)

	blended := deduplicateTracks(append(pTracks, sTracks...))
	blended = overrideURLs(blended)
	uc.PreFetchStreamURLs(blended, 3, explicit, quality)
	return blended, nil
}

// SearchRaw performs a raw search directly against the repository without 70/30 algorithm.
func (uc *TrackUseCase) SearchRaw(ctx context.Context, query string, limit, offset int, explicit bool, quality int) ([]*domain.Track, error) {
	if query == "" {
		return nil, ErrEmptyVibe
	}
	if limit <= 0 {
		limit = 20
	}
	tracks, err := uc.repo.SearchByVibe(ctx, query, limit, offset, explicit)
	if err == nil {
		tracks = deduplicateTracks(tracks)
		tracks = overrideURLs(tracks)
		uc.PreFetchStreamURLs(tracks, 3, explicit, quality)
	}
	return tracks, err
}

// SearchMulti performs a concurrent 3-way search for songs, albums, and artists.
func (uc *TrackUseCase) SearchMulti(ctx context.Context, query string, limit int, explicit bool, quality int) (*domain.SearchResult, error) {
	if query == "" {
		return nil, ErrEmptyVibe
	}
	type multiSearcher interface {
		SearchMulti(ctx context.Context, query string, limit int, explicit bool) (*domain.SearchResult, error)
	}
	ms, ok := uc.repo.(multiSearcher)
	if !ok {
		tracks, err := uc.repo.SearchByVibe(ctx, query, limit, 0, explicit)
		if err != nil {
			return nil, err
		}
		tracks = deduplicateTracks(tracks)
		return &domain.SearchResult{Songs: tracks, Albums: []*domain.Track{}, Artists: []*domain.Track{}}, nil
	}
	res, err := ms.SearchMulti(ctx, query, limit, explicit)
	if err == nil {
		res.Songs = deduplicateTracks(overrideURLs(res.Songs))
		res.Albums = overrideURLs(res.Albums)
		res.Artists = overrideURLs(res.Artists)
		uc.PreFetchStreamURLs(res.Songs, 3, explicit, quality)
	}
	return res, err
}

// GetAlbumDetail retrieves album metadata and its tracks.
