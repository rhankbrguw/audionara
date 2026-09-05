// Package repository provides data access and caching adapters.
package repository

import (
	"context"
	"encoding/json"
	"strings"
	"sync"
	"time"

	"github.com/redis/go-redis/v9"
	"github.com/user/audionara/backend/internal/domain"
)

// CacheRepository defines methods for caching recommendations, streams, and catalog metadata.
type CacheRepository interface {
	GetMix(ctx context.Context, deviceID string) ([]*domain.Track, error)
	SetMix(ctx context.Context, deviceID string, mix []*domain.Track, ttl time.Duration) error
	GetLyrics(ctx context.Context, artist, title string) (string, error)
	SetLyrics(ctx context.Context, artist, title, lyrics string, ttl time.Duration) error
	GetStreamURL(ctx context.Context, artist, title string) (string, error)
	SetStreamURL(ctx context.Context, artist, title, streamURL string, ttl time.Duration) error
	GetJSON(ctx context.Context, key string, dest any) error
	SetJSON(ctx context.Context, key string, src any, ttl time.Duration) error
}

type memoryEntry struct {
	value     string
	expiresAt time.Time
}

type redisCacheRepo struct {
	client  *redis.Client
	l1Cache sync.Map
}

// NewCacheRepository creates a new Redis-backed CacheRepository with L1 cache.
func NewCacheRepository(client *redis.Client) CacheRepository {
	return &redisCacheRepo{client: client}
}

// GetMix retrieves the Mix based on the provided parameters.
func (r *redisCacheRepo) GetMix(ctx context.Context, deviceID string) ([]*domain.Track, error) {
	key := "mix:" + deviceID
	var mix []*domain.Track
	if err := r.GetJSON(ctx, key, &mix); err != nil {
		return nil, err
	}
	return mix, nil
}

// SetMix provides SetMix functionality.
func (r *redisCacheRepo) SetMix(ctx context.Context, deviceID string, mix []*domain.Track, ttl time.Duration) error {
	key := "mix:" + deviceID
	return r.SetJSON(ctx, key, mix, ttl)
}

// GetLyrics retrieves the Lyrics based on the provided parameters.
func (r *redisCacheRepo) GetLyrics(ctx context.Context, artist, title string) (string, error) {
	key := "lyrics:" + strings.ToLower(strings.TrimSpace(artist)) + ":" + strings.ToLower(strings.TrimSpace(title))
	return r.client.Get(ctx, key).Result()
}

// SetLyrics provides SetLyrics functionality.
func (r *redisCacheRepo) SetLyrics(ctx context.Context, artist, title, lyrics string, ttl time.Duration) error {
	key := "lyrics:" + strings.ToLower(strings.TrimSpace(artist)) + ":" + strings.ToLower(strings.TrimSpace(title))
	return r.client.Set(ctx, key, lyrics, ttl).Err()
}

// GetStreamURL retrieves stream URL from L1 memory or Redis L2.
func (r *redisCacheRepo) GetStreamURL(ctx context.Context, artist, title string) (string, error) {
	key := "stream:" + strings.ToLower(strings.TrimSpace(artist)) + ":" + strings.ToLower(strings.TrimSpace(title))
	if val, ok := r.l1Cache.Load(key); ok {
		entry := val.(memoryEntry)
		if time.Now().Before(entry.expiresAt) {
			return entry.value, nil
		}
		r.l1Cache.Delete(key)
	}
	url, err := r.client.Get(ctx, key).Result()
	if err == nil && url != "" {
		r.l1Cache.Store(key, memoryEntry{value: url, expiresAt: time.Now().Add(10 * time.Minute)})
	}
	return url, err
}

// SetStreamURL caches stream URL into L1 memory and Redis L2.
func (r *redisCacheRepo) SetStreamURL(ctx context.Context, artist, title, streamURL string, ttl time.Duration) error {
	key := "stream:" + strings.ToLower(strings.TrimSpace(artist)) + ":" + strings.ToLower(strings.TrimSpace(title))
	r.l1Cache.Store(key, memoryEntry{value: streamURL, expiresAt: time.Now().Add(ttl)})
	return r.client.Set(ctx, key, streamURL, ttl).Err()
}

// GetJSON unmarshals a cached JSON payload into dest.
func (r *redisCacheRepo) GetJSON(ctx context.Context, key string, dest any) error {
	val, err := r.client.Get(ctx, key).Result()
	if err != nil {
		return err
	}
	return json.Unmarshal([]byte(val), dest)
}

// SetJSON marshals src and caches it in Redis with the given TTL.
func (r *redisCacheRepo) SetJSON(ctx context.Context, key string, src any, ttl time.Duration) error {
	data, err := json.Marshal(src)
	if err != nil {
		return err
	}
	return r.client.Set(ctx, key, data, ttl).Err()
}


