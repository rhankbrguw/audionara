package usecase

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

func fetchTopChartArtists() []domain.HomeArtist {
	client := &http.Client{Timeout: 5 * time.Second}
	resp, err := client.Get("https://api.deezer.com/chart/0/artists?limit=5")
	if err != nil {
		return nil
	}
	defer resp.Body.Close()

	var payload struct {
		Data []struct {
			ID      int64  `json:"id"`
			Name    string `json:"name"`
			Picture string `json:"picture_big"`
		} `json:"data"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil
	}

	artists := make([]domain.HomeArtist, 0, len(payload.Data))
	for _, a := range payload.Data {
		artists = append(artists, domain.HomeArtist{ID: a.ID, Name: a.Name, Picture: a.Picture})
	}
	return artists
}

func fetchArtistByName(name string) *domain.HomeArtist {
	client := &http.Client{Timeout: 4 * time.Second}
	resp, err := client.Get("https://api.deezer.com/search/artist?q=" + url.QueryEscape(name) + "&limit=1")
	if err != nil {
		return nil
	}
	defer resp.Body.Close()

	var payload struct {
		Data []struct {
			ID      int64  `json:"id"`
			Name    string `json:"name"`
			Picture string `json:"picture_big"`
		} `json:"data"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil || len(payload.Data) == 0 {
		return nil
	}
	return &domain.HomeArtist{ID: payload.Data[0].ID, Name: payload.Data[0].Name, Picture: payload.Data[0].Picture}
}

func fetchUserTopArtists(historyRepo domain.HistoryRepository, deviceID string) []domain.HomeArtist {
	if historyRepo == nil || deviceID == "" {
		return fetchTopChartArtists()
	}
	topNames, err := historyRepo.GetTopArtists(deviceID, 5)
	if err != nil || len(topNames) == 0 {
		return fetchTopChartArtists()
	}

	var results []domain.HomeArtist
	for _, name := range topNames {
		if a := fetchArtistByName(name); a != nil {
			results = append(results, *a)
		}
	}
	if len(results) < 5 {
		charts := fetchTopChartArtists()
		for _, c := range charts {
			if len(results) >= 5 {
				break
			}
			if !containsArtist(results, c.ID) {
				results = append(results, c)
			}
		}
	}
	return results
}

func fetchRelatedArtists(artistID int64) []domain.HomeArtist {
	if artistID <= 0 {
		return nil
	}
	client := &http.Client{Timeout: 4 * time.Second}
	resp, err := client.Get(fmt.Sprintf("https://api.deezer.com/artist/%d/related?limit=5", artistID))
	if err != nil {
		return nil
	}
	defer resp.Body.Close()

	var payload struct {
		Data []struct {
			ID      int64  `json:"id"`
			Name    string `json:"name"`
			Picture string `json:"picture_big"`
		} `json:"data"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil
	}

	artists := make([]domain.HomeArtist, 0, len(payload.Data))
	for _, a := range payload.Data {
		artists = append(artists, domain.HomeArtist{ID: a.ID, Name: a.Name, Picture: a.Picture})
	}
	return artists
}

func containsArtist(list []domain.HomeArtist, id int64) bool {
	for _, a := range list {
		if a.ID == id {
			return true
		}
	}
	return false
}

func resolveFallbackVibeCover(name string) string {
	lower := strings.ToLower(name)
	switch {
	case strings.Contains(lower, "acoustic"):
		return "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"
	case strings.Contains(lower, "pop"):
		return "https://cdn-images.dzcdn.net/images/artist/877872aaf75694f11d53c318700ab2b5/500x500-000000-80-0-0.jpg"
	case strings.Contains(lower, "lo-fi") || strings.Contains(lower, "lofi"):
		return "https://cdn-images.dzcdn.net/images/cover/5e559948ec740c763a6c14aadff3c395/500x500-000000-80-0-0.jpg"
	case strings.Contains(lower, "rock") || strings.Contains(lower, "punk"):
		return "https://cdn-images.dzcdn.net/images/cover/f8a0a2e1ec12c1026cd03208237cd934/500x500-000000-80-0-0.jpg"
	case strings.Contains(lower, "r&b") || strings.Contains(lower, "soul"):
		return "https://cdn-images.dzcdn.net/images/artist/581693b4724a7fcfa754455101e13a44/500x500-000000-80-0-0.jpg"
	case strings.Contains(lower, "drive") || strings.Contains(lower, "synth"):
		return "https://cdn-images.dzcdn.net/images/artist/b18856da7850c8b8cb10476fefc15657/500x500-000000-80-0-0.jpg"
	case strings.Contains(lower, "focus") || strings.Contains(lower, "chill"):
		return "https://cdn-images.dzcdn.net/images/artist/638e69b9caaf9f9f3f8826febea7b543/500x500-000000-80-0-0.jpg"
	default:
		return "https://cdn-images.dzcdn.net/images/artist/6c03e4c7c36800897fd468633286db24/500x500-000000-80-0-0.jpg"
	}
}
