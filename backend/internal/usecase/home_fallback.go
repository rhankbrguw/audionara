package usecase

import (
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

var defaultArtists = []domain.HomeArtist{
	{ID: 12246, Name: "Taylor Swift", Picture: "https://cdn-images.dzcdn.net/images/artist/e528e270424103b527f8a27ac625563b/500x500-000000-80-0-0.jpg"},
	{ID: 4050205, Name: "The Weeknd", Picture: "https://cdn-images.dzcdn.net/images/artist/581693b4724a7fcfa754455101e13a44/500x500-000000-80-0-0.jpg"},
	{ID: 384236, Name: "Ed Sheeran", Picture: "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"},
	{ID: 1562681, Name: "Ariana Grande", Picture: "https://cdn-images.dzcdn.net/images/artist/721d8fab84b315502de422b8d0901509/500x500-000000-80-0-0.jpg"},
	{ID: 288166, Name: "Justin Bieber", Picture: "https://cdn-images.dzcdn.net/images/artist/fe097f693cebf1f882e3da79e99e3bf9/500x500-000000-80-0-0.jpg"},
}

// GetHomeFeedFallback returns dynamic feed data based on current context.
func (uc *HomeUseCase) GetHomeFeedFallback() *domain.HomeFeed {
	return uc.GetDynamicFallback(nil, 0)
}

func resolveChartArtists(artists []domain.HomeArtist) []domain.HomeArtist {
	if len(artists) > 0 {
		return artists
	}
	if charts := fetchTopChartArtists(); len(charts) > 0 {
		return charts
	}
	return defaultArtists
}

// GetDynamicFallback produces dynamic vibes based on time of day and user top artists.
func (uc *HomeUseCase) GetDynamicFallback(artists []domain.HomeArtist, seed int) *domain.HomeFeed {
	chartArtists := resolveChartArtists(artists)
	now := time.Now().In(wibZone)
	vibes := buildDynamicVibes(chartArtists, now.Hour())
	chosenIdx := 0
	if seed > 0 {
		chosenIdx = seed % len(chartArtists)
	} else {
		chosenIdx = (now.Hour() + now.Day()) % len(chartArtists)
	}
	chosenArtist := chartArtists[chosenIdx]

	similar := fetchRelatedArtists(chosenArtist.ID)
	if len(similar) == 0 {
		similar = fallbackSimilarArtists(chartArtists, chosenArtist.Name)
	}

	return &domain.HomeFeed{
		TrendingHits:    getCuratedTrendingHits(),
		ExploreVibes:    vibes,
		FavoriteArtists: chartArtists,
		BaseArtist:      chosenArtist.Name,
		SimilarArtists:  similar,
	}
}

func fallbackSimilarArtists(artists []domain.HomeArtist, currentName string) []domain.HomeArtist {
	var result []domain.HomeArtist
	for _, a := range artists {
		if a.Name != currentName {
			result = append(result, a)
		}
	}
	return result
}

func getCuratedTrendingHits() []domain.HomeTrending {
	return []domain.HomeTrending{
		{Title: "Global Top 50", Subtitle: "The most played tracks globally", Badge: "HOT", Color1: "#1CB5E0", Color2: "#000046"},
		{Title: "Viral 50", Subtitle: "Trending on the internet right now", Badge: "VIRAL", Color1: "#FF416C", Color2: "#FF4B2B"},
		{Title: "New Releases", Subtitle: "Freshly dropped tracks this week", Badge: "NEW", Color1: "#8E2DE2", Color2: "#4A00E0"},
	}
}

func parseFeedResponse(response string) *domain.HomeFeed {
	clean := strings.TrimSpace(response)
	if strings.HasPrefix(clean, "```json") {
		clean = strings.TrimPrefix(clean, "```json")
		clean = strings.TrimSuffix(clean, "```")
	}
	var feed domain.HomeFeed
	if err := json.Unmarshal([]byte(clean), &feed); err != nil || len(feed.TrendingHits) == 0 {
		return nil
	}
	for i := range feed.ExploreVibes {
		if feed.ExploreVibes[i].Subtitle == "" {
			feed.ExploreVibes[i].Subtitle = fmt.Sprintf("Top tracks & sonic inspirations in %s", feed.ExploreVibes[i].Name)
		}
		if feed.ExploreVibes[i].Cover == "" {
			feed.ExploreVibes[i].Cover = resolveFallbackVibeCover(feed.ExploreVibes[i].Name)
		}
	}
	return &feed
}
