// Package usecase contains the MixForYou personalization algorithm.
package usecase

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/pkg/gemini"
)

// GetMixForYou generates a hyper-personalized mix using Gemini and Postgres History.
func (uc *TrackUseCase) GetMixForYou(ctx context.Context, deviceID string, limit int, explicit bool, quality int) ([]*domain.Track, error) {
	if limit <= 0 {
		limit = 30
	}

	if deviceID != "" {
		if cachedMix, err := uc.cacheRepo.GetMix(ctx, deviceID); err == nil && len(cachedMix) > 0 {
			return cachedMix, nil
		}
	}

	historySummary, topArtist := uc.fetchHistorySummary(deviceID)
	prompt := buildMixPrompt(historySummary, time.Now().Hour())

	go uc.generateAndCacheMix(prompt, deviceID, limit, explicit, quality)

	return uc.fetchFastFallbackMix(ctx, topArtist, limit, explicit, quality), nil
}

func (uc *TrackUseCase) fetchHistorySummary(deviceID string) (string, string) {
	if deviceID == "" {
		return "", ""
	}
	history, err := uc.historyRepo.GetRecentHistory(deviceID, 10)
	if err != nil || len(history) == 0 {
		return "", ""
	}
	var items []string
	topArtist := history[0].Artist
	for _, h := range history {
		items = append(items, fmt.Sprintf("%s by %s", h.Title, h.Artist))
	}
	return strings.Join(items, ", "), topArtist
}

func buildMixPrompt(historySummary string, hour int) string {
	currentDate := time.Now().Format("2006-01-02")
	timeContext := "late night"
	if hour >= 5 && hour < 12 {
		timeContext = "morning"
	} else if hour >= 12 && hour < 17 {
		timeContext = "afternoon"
	} else if hour >= 17 && hour < 22 {
		timeContext = "evening"
	}

	if historySummary != "" {
		return fmt.Sprintf("You are an industry-leading collaborative filtering engine. Today is %s and the time is %s. A user recently listened to: [%s]. Based on global user behavior matrices, generate exactly 3 highly specific, short search queries (e.g., 'upbeat acoustic pop', 'lo-fi study beats', 'viral hip hop 2024') that will return fresh music they will fall in love with. Do not repeat generic queries. Return ONLY the 3 queries separated by commas, no other text.", currentDate, timeContext, historySummary)
	}
	return fmt.Sprintf("You are an industry-leading collaborative filtering engine. Today is %s and the time is %s. Generate exactly 3 highly specific, short search queries that fit this time and season perfectly. Return ONLY the 3 queries separated by commas, no other text.", currentDate, timeContext)
}

func (uc *TrackUseCase) generateAndCacheMix(prompt, deviceID string, limit int, explicit bool, quality int) {
	bgCtx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	queries := parseGeminiQueries(prompt)
	limitPerQuery := limit / len(queries)
	if limitPerQuery == 0 {
		limitPerQuery = 10
	}

	mix := uc.fetchParallelQueries(bgCtx, queries, limitPerQuery, explicit)
	if deviceID != "" && len(mix) > 0 {
		mix = overrideURLs(mix)
		uc.PreFetchStreamURLs(mix, 2, explicit, quality)
		if err := uc.cacheRepo.SetMix(bgCtx, deviceID, mix, 4*time.Hour); err != nil {
			// Cache failure is non-fatal for playback
			return
		}
	}
}

func parseGeminiQueries(prompt string) []string {
	response, err := gemini.CallAPI(prompt)
	if err != nil {
		return []string{"Global Top 50", "Trending Hits", "Viral 50"}
	}
	queries := strings.Split(response, ",")
	for i, q := range queries {
		queries[i] = strings.TrimSpace(q)
	}
	if len(queries) == 0 {
		return []string{"Global Top 50", "Trending Hits", "Viral 50"}
	}
	return queries
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
	fallbackQuery := "Global Top 50"
	if query != "" {
		fallbackQuery = query
	}
	fastFallback, err := uc.repo.SearchByVibe(ctx, fallbackQuery, limit, 0, explicit)
	if err != nil || len(fastFallback) == 0 {
		return []*domain.Track{}
	}
	fastFallback = overrideURLs(deduplicateTracks(fastFallback))
	uc.PreFetchStreamURLs(fastFallback, 2, explicit, quality)
	return fastFallback
}
