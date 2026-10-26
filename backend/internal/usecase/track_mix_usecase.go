// Package usecase contains the MixForYou personalization algorithm.
package usecase

import (
	"context"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

// GetMixForYou generates a hyper-personalized mix using user history, top artists, and collaborative filtering.
func (uc *TrackUseCase) GetMixForYou(ctx context.Context, deviceID string, limit int, explicit bool, quality int) ([]*domain.Track, error) {
	if limit <= 0 {
		limit = 30
	}

	if deviceID != "" && uc.cacheRepo != nil {
		if cachedMix, err := uc.cacheRepo.GetMix(ctx, deviceID); err == nil && len(cachedMix) > 0 {
			return cachedMix, nil
		}
	}
	mix := uc.buildPersonalizedMix(ctx, deviceID, limit, explicit)
	if len(mix) == 0 {
		mix = uc.fetchFastFallbackMix(ctx, "Global Top 50", limit, explicit, quality)
	}
	mix = overrideURLs(deduplicateTracks(mix))
	if deviceID != "" && uc.cacheRepo != nil && len(mix) > 0 {
		_ = uc.cacheRepo.SetMix(ctx, deviceID, mix, 30*time.Minute)
	}
	uc.PreFetchStreamURLs(mix, 2, explicit, quality)
	return mix, nil
}

func (uc *TrackUseCase) buildPersonalizedMix(ctx context.Context, deviceID string, limit int, explicit bool) []*domain.Track {
	familiar, discovery := uc.resolveMixArtistQueries(deviceID)
	var familiarTracks []*domain.Track
	if len(familiar) > 0 {
		familiarTracks = uc.fetchParallelQueries(ctx, familiar, 4, explicit)
	}

	perDiscovery := 3
	if len(discovery) > 0 {
		perDiscovery = (limit - len(familiarTracks)) / len(discovery)
		if perDiscovery < 3 {
			perDiscovery = 3
		}
	}
	discoveryTracks := uc.fetchParallelQueries(ctx, discovery, perDiscovery, explicit)
	return blendTracks(familiarTracks, discoveryTracks, limit)
}

func (uc *TrackUseCase) resolveMixArtistQueries(deviceID string) ([]string, []string) {
	var familiar, discovery []string
	seen := make(map[string]bool)
	if uc.historyRepo != nil && deviceID != "" {
		if artists, err := uc.historyRepo.GetTopArtists(deviceID, 3); err == nil && len(artists) > 0 {
			familiar = artists
			for _, a := range artists {
				seen[strings.ToLower(a)] = true
				if obj := fetchArtistByName(a); obj != nil {
					for _, r := range fetchRelatedArtists(obj.ID) {
						if k := strings.ToLower(r.Name); !seen[k] {
							seen[k] = true
							discovery = append(discovery, r.Name)
						}
					}
				}
			}
		}
	}
	if len(discovery) == 0 {
		discovery = getTimeBasedQueries(time.Now().Hour())
	}
	return familiar, discovery
}

func blendTracks(familiar, discovery []*domain.Track, limit int) []*domain.Track {
	var result []*domain.Track
	fIdx, dIdx := 0, 0
	seen := make(map[string]bool)
	addTrack := func(t *domain.Track) {
		if t != nil && !seen[strings.ToLower(t.Title)+":"+strings.ToLower(t.Artist)] {
			seen[strings.ToLower(t.Title)+":"+strings.ToLower(t.Artist)] = true
			result = append(result, t)
		}
	}
	for (fIdx < len(familiar) || dIdx < len(discovery)) && len(result) < limit {
		if fIdx < len(familiar) {
			addTrack(familiar[fIdx])
			fIdx++
		}
		for step := 0; step < 2 && dIdx < len(discovery) && len(result) < limit; step++ {
			addTrack(discovery[dIdx])
			dIdx++
		}
	}
	return result
}

func getTimeBasedQueries(hour int) []string {
	switch {
	case hour >= 5 && hour < 12:
		return []string{"Morning Acoustic Pop", "Indie Chill Morning", "Fresh Pop Hits"}
	case hour >= 12 && hour < 17:
		return []string{"Afternoon Energy Hits", "Lo-Fi Study Beats", "Electronic Work"}
	case hour >= 17 && hour < 22:
		return []string{"Evening Chill", "Synthwave Night Drive", "Trending Pop Hits"}
	default:
		return []string{"Night Drive Beats", "Dark Synthwave", "Mellow Lo-Fi"}
	}
}

func (uc *TrackUseCase) fetchParallelQueries(ctx context.Context, queries []string, limitPerQuery int, explicit bool) []*domain.Track {
	type fetchResult struct {
		tracks []*domain.Track
		err    error
	}
	ch := make(chan fetchResult, len(queries))
	for _, q := range queries {
		go func(query string) {
			t, err := uc.repo.SearchByVibe(ctx, query, limitPerQuery, 0, explicit)
			ch <- fetchResult{t, err}
		}(q)
	}

	var mix []*domain.Track
	for i := 0; i < len(queries); i++ {
		res := <-ch
		if res.err == nil {
			mix = append(mix, res.tracks...)
		}
	}
	return deduplicateTracks(mix)
}

func (uc *TrackUseCase) fetchFastFallbackMix(ctx context.Context, query string, limit int, explicit bool, quality int) []*domain.Track {
	if query == "" {
		query = "Global Top 50"
	}
	tracks, err := uc.repo.SearchByVibe(ctx, query, limit, 0, explicit)
	if err != nil || len(tracks) == 0 {
		return []*domain.Track{}
	}
	tracks = overrideURLs(deduplicateTracks(tracks))
	uc.PreFetchStreamURLs(tracks, 2, explicit, quality)
	return tracks
}
