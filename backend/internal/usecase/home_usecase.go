package usecase

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/repository"
	"github.com/user/audionara/backend/pkg/gemini"
)

// HomeUseCase handles generating dynamic content for the home screen.
type HomeUseCase struct {
	historyRepo domain.HistoryRepository
	cacheRepo   repository.CacheRepository
}

// NewHomeUseCase creates a new HomeUseCase.
func NewHomeUseCase(historyRepo domain.HistoryRepository, cacheRepo repository.CacheRepository) *HomeUseCase {
	return &HomeUseCase{
		historyRepo: historyRepo,
		cacheRepo:   cacheRepo,
	}
}

var wibZone = time.FixedZone("WIB", 7*3600)

// GetHomeFeed returns the dynamic home screen layout instantly.
func (uc *HomeUseCase) GetHomeFeed(ctx context.Context, deviceID string, seed int, forceRefresh bool) (*domain.HomeFeed, error) {
	hour := time.Now().In(wibZone).Hour()
	cacheKey := fmt.Sprintf("home:feed:%s:%d:s%d", deviceID, hour, seed)
	if deviceID == "" {
		cacheKey = fmt.Sprintf("home:feed:global:%d:s%d", hour, seed)
	}

	if !forceRefresh && uc.cacheRepo != nil {
		var cached domain.HomeFeed
		if uc.cacheRepo.GetJSON(ctx, cacheKey, &cached) == nil && len(cached.ExploreVibes) > 0 {
			return &cached, nil
		}
	}

	feed := uc.buildPersonalizedFeed(ctx, deviceID, seed)
	if uc.cacheRepo != nil && feed != nil {
		_ = uc.cacheRepo.SetJSON(ctx, cacheKey, feed, 1*time.Hour)
	}
	return feed, nil
}

func (uc *HomeUseCase) buildPersonalizedFeed(ctx context.Context, deviceID string, seed int) *domain.HomeFeed {
	artists := fetchUserTopArtists(uc.historyRepo, deviceID)
	feed := uc.generateDynamicFeed(ctx, artists)
	if feed == nil {
		feed = uc.GetDynamicFallback(artists, seed)
	}
	if len(artists) > 0 {
		uc.applyDynamicRecommendation(feed, artists, seed)
	} else if len(feed.FavoriteArtists) == 0 {
		fallback := uc.GetDynamicFallback(nil, seed)
		feed.FavoriteArtists = fallback.FavoriteArtists
		feed.BaseArtist = fallback.BaseArtist
		feed.SimilarArtists = fallback.SimilarArtists
	}
	return feed
}

func (uc *HomeUseCase) applyDynamicRecommendation(feed *domain.HomeFeed, artists []domain.HomeArtist, seed int) {
	now := time.Now().In(wibZone)
	chosenIdx := 0
	if seed > 0 {
		chosenIdx = seed % len(artists)
	} else {
		chosenIdx = (now.Hour() + now.Day()) % len(artists)
	}
	chosenArtist := artists[chosenIdx]
	if len(artists) > 5 {
		artists = artists[:5]
	}
	feed.FavoriteArtists = artists
	feed.BaseArtist = chosenArtist.Name
	similar := fetchRelatedArtists(chosenArtist.ID)
	if len(similar) == 0 {
		similar = fallbackSimilarArtists(artists, chosenArtist.Name)
	}
	if len(similar) > 5 {
		similar = similar[:5]
	}
	feed.SimilarArtists = similar
}

func (uc *HomeUseCase) generateDynamicFeed(ctx context.Context, artists []domain.HomeArtist) *domain.HomeFeed {
	geminiCtx, cancel := context.WithTimeout(ctx, 4*time.Second)
	defer cancel()

	prompt := buildFeedPrompt(artists)
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

func buildFeedPrompt(artists []domain.HomeArtist) string {
	currentDate := time.Now().Format("2006-01-02")
	artistContext := ""
	if len(artists) > 0 {
		var names []string
		for _, a := range artists {
			names = append(names, a.Name)
		}
		artistContext = " The user frequently listens to: " + strings.Join(names, ", ") + "."
	}
	return fmt.Sprintf(`You are an AI music director. Today is %s.%s
Generate JSON with "trending_hits" (3 items: title, subtitle, badge, color1, color2) and "explore_vibes" (6 items: name, subtitle, icon, color1, color2). For explore_vibes, create dynamic evocative vibe names and rich subtitles tailored to user artists and time of day. Respond ONLY with valid JSON.`, currentDate, artistContext)
}
