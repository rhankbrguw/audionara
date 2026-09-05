package repository

import (
	"context"
	"fmt"
	"net/url"
	"sort"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

type scoredTrack struct {
	track *domain.Track
	score float64
}

// SearchByVibe searches tracks on Deezer with intelligent curated playlists or chart integration.
func (r *DeezerRepository) SearchByVibe(ctx context.Context, vibe string, limit, offset int, explicit bool) ([]*domain.Track, error) {
	if limit <= 0 {
		limit = 20
	}
	cacheKey := fmt.Sprintf("search:vibe:%s:%d:%d:%t", vibe, limit, offset, explicit)
	var cached []*domain.Track
	if r.cacheRepo != nil && r.cacheRepo.GetJSON(ctx, cacheKey, &cached) == nil && len(cached) > 0 {
		return cached, nil
	}

	tracks, err := r.executeVibeSearch(ctx, vibe, limit, offset, explicit)
	if err != nil {
		return nil, err
	}

	if r.cacheRepo != nil && len(tracks) > 0 {
		_ = r.cacheRepo.SetJSON(ctx, cacheKey, tracks, 30*time.Minute)
	}
	return tracks, nil
}

func (r *DeezerRepository) executeVibeSearch(ctx context.Context, vibe string, limit, offset int, explicit bool) ([]*domain.Track, error) {
	norm := strings.ToLower(strings.TrimSpace(vibe))
	if isGlobalTopChartQuery(norm) {
		return r.fetchChartTracks(ctx, limit, explicit)
	}

	curatedQuery := resolveCuratedVibeQuery(vibe)
	if tracks, err := r.fetchCuratedPlaylistTracks(ctx, curatedQuery, limit, offset); err == nil && len(tracks) > 0 {
		return filterTracksByExplicit(tracks, explicit), nil
	}

	return r.performDeezerSearch(ctx, vibe, limit, offset, explicit)
}

func isGlobalTopChartQuery(norm string) bool {
	return strings.Contains(norm, "global top") || norm == "chart" || norm == "charts" || norm == "top 50"
}

func (r *DeezerRepository) fetchChartTracks(ctx context.Context, limit int, explicit bool) ([]*domain.Track, error) {
	endpoint := fmt.Sprintf("/chart/0/tracks?limit=%d", limit*2)
	var payload struct {
		Data []deezerTrackDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, endpoint, &payload); err != nil {
		return nil, err
	}
	tracks := make([]*domain.Track, 0, len(payload.Data))
	for _, dto := range payload.Data {
		if !explicit && dto.ExplicitLyrics {
			continue
		}
		if dto.Title != "" || dto.TitleShort != "" {
			tracks = append(tracks, mapDeezerTrackToDomain(dto))
		}
		if len(tracks) >= limit {
			break
		}
	}
	return tracks, nil
}

func (r *DeezerRepository) performDeezerSearch(ctx context.Context, query string, limit, offset int, explicit bool) ([]*domain.Track, error) {
	escaped := url.QueryEscape(query)
	endpoint := fmt.Sprintf("/search?q=%s&limit=%d&index=%d", escaped, limit*2, offset)

	var payload struct {
		Data []deezerTrackDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, endpoint, &payload); err != nil {
		return nil, err
	}

	ranked := rankAndSortTracks(query, payload.Data, explicit)
	if len(ranked) > limit {
		ranked = ranked[:limit]
	}
	return ranked, nil
}

func rankAndSortTracks(query string, dtos []deezerTrackDTO, explicit bool) []*domain.Track {
	scored := make([]scoredTrack, 0, len(dtos))
	seen := make(map[string]bool, len(dtos))
	for _, dto := range dtos {
		if !explicit && dto.ExplicitLyrics {
			continue
		}
		if dto.Title == "" && dto.TitleShort == "" {
			continue
		}
		key := strings.ToLower(dto.Title) + ":" + strings.ToLower(dto.Artist.Name)
		if seen[key] {
			continue
		}
		seen[key] = true
		scored = append(scored, scoredTrack{
			track: mapDeezerTrackToDomain(dto),
			score: computeScore(query, dto),
		})
	}

	sort.Slice(scored, func(i, j int) bool {
		return scored[i].score > scored[j].score
	})

	result := make([]*domain.Track, 0, len(scored))
	for _, s := range scored {
		result = append(result, s.track)
	}
	return result
}

func computeScore(query string, dto deezerTrackDTO) float64 {
	q := strings.ToLower(strings.TrimSpace(query))
	title, artist := strings.ToLower(dto.Title), strings.ToLower(dto.Artist.Name)
	var score float64

	if title == q {
		score += 1000
	} else if strings.Contains(title, q) {
		score += 200
	}
	if artist == q {
		score += 800
	} else if strings.Contains(artist, q) {
		score += 150
	}
	return score + (float64(dto.Rank) / 1000.0)
}
