package usecase

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
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
