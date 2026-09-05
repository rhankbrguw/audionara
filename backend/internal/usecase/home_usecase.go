package usecase

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/repository"
	"github.com/user/audionara/backend/pkg/gemini"
)

// HomeUseCase handles generating dynamic content for the home screen.
type HomeUseCase struct {
	historyRepo domain.HistoryRepository
	cacheRepo   repository.CacheRepository
	mu          sync.RWMutex
	cachedFeed  *domain.HomeFeed
}

// NewHomeUseCase creates a new HomeUseCase.
func NewHomeUseCase(historyRepo domain.HistoryRepository, cacheRepo repository.CacheRepository) *HomeUseCase {
	return &HomeUseCase{
		historyRepo: historyRepo,
		cacheRepo:   cacheRepo,
	}
}

// GetHomeFeed returns the dynamic home screen layout instantly.
func (uc *HomeUseCase) GetHomeFeed(ctx context.Context, deviceID string) (*domain.HomeFeed, error) {
	uc.mu.RLock()
	if uc.cachedFeed != nil && deviceID == "" {
		feed := uc.cachedFeed
		uc.mu.RUnlock()
		return feed, nil
	}
	uc.mu.RUnlock()

	cacheKey := "home:feed:" + deviceID
	if deviceID == "" {
		cacheKey = "home:feed:global"
	}
	var cached domain.HomeFeed
	if uc.cacheRepo != nil && uc.cacheRepo.GetJSON(ctx, cacheKey, &cached) == nil && len(cached.ExploreVibes) > 0 {
		if deviceID == "" {
			uc.mu.Lock()
			uc.cachedFeed = &cached
			uc.mu.Unlock()
		}
		return &cached, nil
	}

	feed := uc.buildPersonalizedFeed(ctx, deviceID)
	if uc.cacheRepo != nil && feed != nil {
		_ = uc.cacheRepo.SetJSON(ctx, cacheKey, feed, 24*time.Hour)
	}
	if deviceID == "" && feed != nil {
		uc.mu.Lock()
		uc.cachedFeed = feed
		uc.mu.Unlock()
	}
	return feed, nil
}

func (uc *HomeUseCase) buildPersonalizedFeed(ctx context.Context, deviceID string) *domain.HomeFeed {
	artists := fetchUserTopArtists(uc.historyRepo, deviceID)
	feed := uc.generateDynamicFeed(ctx, artists)
	if feed == nil {
		feed = uc.GetHomeFeedFallback()
	}
	if len(artists) > 0 {
		if len(artists) > 5 {
			artists = artists[:5]
		}
		feed.FavoriteArtists = artists
		feed.BaseArtist = artists[0].Name
		similar := fetchRelatedArtists(artists[0].ID)
		if len(similar) > 5 {
			similar = similar[:5]
		}
		feed.SimilarArtists = similar
	} else if len(feed.FavoriteArtists) == 0 {
		fallback := uc.GetHomeFeedFallback()
		feed.FavoriteArtists = fallback.FavoriteArtists
		feed.BaseArtist = fallback.BaseArtist
		feed.SimilarArtists = fallback.SimilarArtists
	}
	return feed
}

func (uc *HomeUseCase) generateDynamicFeed(ctx context.Context, artists []domain.HomeArtist) *domain.HomeFeed {
	geminiCtx, cancel := context.WithTimeout(ctx, 1*time.Second)
	defer cancel()

	currentDate := time.Now().Format("2006-01-02")
	artistContext := ""
	if len(artists) > 0 {
		var names []string
		for _, a := range artists {
			names = append(names, a.Name)
		}
		artistContext = " The user frequently listens to: " + strings.Join(names, ", ") + "."
	}

	prompt := fmt.Sprintf(`You are an AI music director. Today is %s.%s
Generate JSON with "trending_hits" (3 items: title, subtitle, badge, color1, color2) and "explore_vibes" (6 items: name, icon, color1, color2). Respond ONLY with valid JSON.`, currentDate, artistContext)

	type gemResult struct {
		resp string
		err  error
	}
	ch := make(chan gemResult, 1)
	go func() {
		r, e := gemini.CallAPI(prompt)
		ch <- gemResult{resp: r, err: e}
	}()

	select {
	case <-geminiCtx.Done():
		return nil
	case res := <-ch:
		if res.err != nil {
			return nil
		}
		return parseFeedResponse(res.resp)
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
	return &feed
}
