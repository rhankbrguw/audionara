package usecase_test

import (
	"context"
	"testing"
	"time"

	"github.com/user/audionara/backend/internal/domain"
	"github.com/user/audionara/backend/internal/usecase"
)

type mockTrackRepo struct {
	searchByVibeFn func(ctx context.Context, vibe string, limit, offset int, explicit bool) ([]*domain.Track, error)
}

func (m *mockTrackRepo) SearchByVibe(ctx context.Context, vibe string, limit, offset int, explicit bool) ([]*domain.Track, error) {
	if m.searchByVibeFn != nil {
		return m.searchByVibeFn(ctx, vibe, limit, offset, explicit)
	}
	return nil, nil
}
func (m *mockTrackRepo) FindByID(ctx context.Context, id string) (*domain.Track, error) {
	return nil, nil
}
func (m *mockTrackRepo) FindAll(ctx context.Context) ([]*domain.Track, error) { return nil, nil }
func (m *mockTrackRepo) Save(ctx context.Context, track *domain.Track) error  { return nil }
func (m *mockTrackRepo) Delete(ctx context.Context, id string) error          { return nil }
func (m *mockTrackRepo) GetAlbumDetail(ctx context.Context, albumID string) (*domain.AlbumDetail, error) {
	return nil, nil
}
func (m *mockTrackRepo) GetArtistTopSongs(ctx context.Context, artistID string, explicit bool) ([]*domain.Track, error) {
	return nil, nil
}
func (m *mockTrackRepo) GetArtistDetail(ctx context.Context, artistID string) (*domain.ArtistDetail, error) {
	return nil, nil
}

type mockHistoryRepo struct{}

func (m *mockHistoryRepo) LogPlay(record *domain.HistoryRecord) error { return nil }
func (m *mockHistoryRepo) GetRecentHistory(deviceID string, limit int) ([]*domain.HistoryRecord, error) {
	return nil, nil
}
func (m *mockHistoryRepo) GetTopArtists(deviceID string, limit int) ([]string, error) {
	return []string{"Nirvana", "Queen"}, nil
}

type mockCacheRepo struct{}

func (m *mockCacheRepo) GetMix(ctx context.Context, deviceID string) ([]*domain.Track, error) {
	return nil, nil
}
func (m *mockCacheRepo) SetMix(ctx context.Context, deviceID string, mix []*domain.Track, ttl time.Duration) error {
	return nil
}
func (m *mockCacheRepo) GetLyrics(ctx context.Context, artist, title string) (string, error) {
	return "", nil
}
func (m *mockCacheRepo) SetLyrics(ctx context.Context, artist, title, lyrics string, ttl time.Duration) error {
	return nil
}
func (m *mockCacheRepo) GetStreamURL(ctx context.Context, artist, title string) (string, error) {
	return "", nil
}
func (m *mockCacheRepo) SetStreamURL(ctx context.Context, artist, title, streamURL string, ttl time.Duration) error {
	return nil
}
func (m *mockCacheRepo) GetJSON(ctx context.Context, key string, dest any) error {
	return nil
}
func (m *mockCacheRepo) SetJSON(ctx context.Context, key string, src any, ttl time.Duration) error {
	return nil
}


func TestTrackUseCase_SearchByVibe(t *testing.T) {
	tests := []struct {
		name    string
		vibe    string
		limit   int
		wantErr bool
	}{
		{
			name:    "empty vibe returns error",
			vibe:    "",
			limit:   10,
			wantErr: true,
		},
		{
			name:    "valid vibe returns tracks",
			vibe:    "chill",
			limit:   10,
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &mockTrackRepo{
				searchByVibeFn: func(ctx context.Context, vibe string, limit, offset int, explicit bool) ([]*domain.Track, error) {
					return []*domain.Track{{ID: "1", Title: "Test"}}, nil
				},
			}
			uc := usecase.NewTrackUseCase(repo, &mockHistoryRepo{}, &mockCacheRepo{})

			tracks, err := uc.SearchByVibe(context.Background(), tt.vibe, tt.limit, 0, false, 0)
			if tt.wantErr {
				if err == nil {
					t.Errorf("expected error, got nil")
				}
			} else {
				if err != nil {
					t.Errorf("unexpected error: %v", err)
				}
				if len(tracks) == 0 {
					t.Errorf("expected tracks, got 0")
				}
			}
		})
	}
}
