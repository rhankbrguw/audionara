package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	"github.com/user/audionara/backend/internal/domain"
)

type itunesSongItem struct {
	TrackID          int64  `json:"trackId"`
	TrackName        string `json:"trackName"`
	ArtistName       string `json:"artistName"`
	ArtistID         int64  `json:"artistId"`
	CollectionID     int64  `json:"collectionId"`
	PreviewURL       string `json:"previewUrl"`
	ArtworkURL100    string `json:"artworkUrl100"`
	TrackTimeMillis  int    `json:"trackTimeMillis"`
	TrackNumber      int    `json:"trackNumber"`
	PrimaryGenreName string `json:"primaryGenreName"`
}

type itunesAlbumItem struct {
	CollectionID     int64  `json:"collectionId"`
	CollectionName   string `json:"collectionName"`
	ArtistName       string `json:"artistName"`
	ArtistID         int64  `json:"artistId"`
	ArtworkURL100    string `json:"artworkUrl100"`
	ReleaseDate      string `json:"releaseDate"`
	TrackCount       int    `json:"trackCount"`
	PrimaryGenreName string `json:"primaryGenreName"`
}

func fetchArtistTopSongsFromITunes(ctx context.Context, artistName string) []*domain.Track {
	client := &http.Client{Timeout: 5 * time.Second}
	reqURL := fmt.Sprintf("https://itunes.apple.com/search?term=%s&entity=song&limit=25", url.QueryEscape(artistName))
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, reqURL, nil)
	if err != nil {
		return nil
	}
	req.Header.Set("User-Agent", "Mozilla/5.0")

	resp, err := client.Do(req)
	if err != nil || resp.StatusCode != http.StatusOK {
		return nil
	}
	defer resp.Body.Close()

	var payload struct {
		Results []itunesSongItem `json:"results"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil
	}

	tracks := make([]*domain.Track, 0, len(payload.Results))
	for _, item := range payload.Results {
		if !strings.EqualFold(item.ArtistName, artistName) && !strings.Contains(strings.ToLower(item.ArtistName), strings.ToLower(artistName)) {
			continue
		}
		cover := strings.Replace(item.ArtworkURL100, "100x100bb.jpg", "600x600bb.jpg", 1)
		tracks = append(tracks, &domain.Track{
			ID:          strconv.FormatInt(item.TrackID, 10),
			Title:       item.TrackName,
			Artist:      item.ArtistName,
			StreamURL:   item.PreviewURL,
			CoverArt:    cover,
			DurationMs:  item.TrackTimeMillis,
			TrackNumber: item.TrackNumber,
			AlbumID:     strconv.FormatInt(item.CollectionID, 10),
			ArtistID:    strconv.FormatInt(item.ArtistID, 10),
		})
	}
	return tracks
}

func fetchArtistAlbumsFromITunes(ctx context.Context, artistName string) []*domain.AlbumMeta {
	client := &http.Client{Timeout: 5 * time.Second}
	reqURL := fmt.Sprintf("https://itunes.apple.com/search?term=%s&entity=album&limit=25", url.QueryEscape(artistName))
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, reqURL, nil)
	if err != nil {
		return nil
	}
	req.Header.Set("User-Agent", "Mozilla/5.0")

	resp, err := client.Do(req)
	if err != nil || resp.StatusCode != http.StatusOK {
		return nil
	}
	defer resp.Body.Close()

	var payload struct {
		Results []itunesAlbumItem `json:"results"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil
	}

	albums := make([]*domain.AlbumMeta, 0, len(payload.Results))
	for _, item := range payload.Results {
		cover := strings.Replace(item.ArtworkURL100, "100x100bb.jpg", "600x600bb.jpg", 1)
		year := ""
		if len(item.ReleaseDate) >= 4 {
			year = item.ReleaseDate[:4]
		}
		albums = append(albums, &domain.AlbumMeta{
			ID:          strconv.FormatInt(item.CollectionID, 10),
			Title:       item.CollectionName,
			Artist:      item.ArtistName,
			ArtistID:    strconv.FormatInt(item.ArtistID, 10),
			CoverArt:    cover,
			Genre:       item.PrimaryGenreName,
			Year:        year,
			TrackCount:  item.TrackCount,
			ReleaseDate: item.ReleaseDate,
			RecordType:  "album",
		})
	}
	return albums
}

func (r *DeezerRepository) resolveTargetArtistID(ctx context.Context, artistID string) string {
	if _, err := strconv.ParseInt(artistID, 10, 64); err == nil {
		return artistID
	}
	var sPayload struct {
		Data []deezerArtistDTO `json:"data"`
	}
	endpoint := "/search/artist?q=" + url.QueryEscape(artistID) + "&limit=1"
	if err := r.fetchJSON(ctx, endpoint, &sPayload); err == nil && len(sPayload.Data) > 0 {
		return strconv.FormatInt(sPayload.Data[0].ID, 10)
	}
	return artistID
}

func extractArtistGenres(albums []*domain.AlbumMeta) []string {
	for _, a := range albums {
		if a.Genre != "" {
			return []string{a.Genre}
		}
	}
	return []string{}
}
