// Package usecase contains application business logic.
package usecase

import (
	"context"
	"errors"
	"strings"
	"sync"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/repository"
)

// ErrEmptyVibe is returned when a caller passes a blank search term.
var ErrEmptyVibe = errors.New("vibe must not be empty")

var (
	vibeWeights = make(map[string]int)
	vibeMu      sync.RWMutex
)

// RecordMetric updates the vibe weights based on user skips/completions.
func (uc *TrackUseCase) RecordMetric(trackID, vibe, action string) {
	vibe = strings.ToLower(vibe)
	vibeMu.Lock()
	defer vibeMu.Unlock()

	if action == "skip" {
		vibeWeights[vibe]--
	} else if action == "complete" {
		vibeWeights[vibe]++
	}
}

// TrackUseCase orchestrates track search logic.
type TrackUseCase struct {
	repo        domain.TrackRepository
	historyRepo domain.HistoryRepository
	cacheRepo   repository.CacheRepository
	flight      *StreamFlightGroup
}

// NewTrackUseCase constructs a TrackUseCase.
func NewTrackUseCase(repo domain.TrackRepository, historyRepo domain.HistoryRepository, cacheRepo repository.CacheRepository) *TrackUseCase {
	return &TrackUseCase{
		repo:        repo,
		historyRepo: historyRepo,
		cacheRepo:   cacheRepo,
		flight:      NewStreamFlightGroup(),
	}
}

// LogPlay logs a track play for a device.
func (uc *TrackUseCase) LogPlay(ctx context.Context, record *domain.HistoryRecord) error {
	return uc.historyRepo.LogPlay(record)
}
