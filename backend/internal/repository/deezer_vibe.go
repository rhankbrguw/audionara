package repository

import (
	"context"
	"fmt"
	"net/url"
	"strings"

	"github.com/user/audionara/backend/internal/domain"
)

var curatedPlaylistMap = map[string]int64{
	"global top":   3155776842,
	"viral":        1313621735,
	"new release":  1282495565,
	"lo-fi":        3338949242,
	"lofi":         3338949242,
	"deep focus":   1195092841,
	"workout":      9647710102,
	"sleep":        4590807924,
	"acoustic":     7393760844,
	"party":        2159765062,
	"80s":          8512471762,
	"eighties":     8512471762,
	"90s":          8873744282,
	"nineties":     8873744282,
	"classic rock": 1578812305,
	"indie rock":   1306978785,
}

func resolveCuratedVibeQuery(vibe string) string {
	norm := strings.ToLower(strings.TrimSpace(vibe))
	switch {
	case strings.Contains(norm, "workout") || strings.Contains(norm, "gym") || strings.Contains(norm, "fitness"):
		return "workout"
	case strings.Contains(norm, "lo-fi") || strings.Contains(norm, "lofi") || strings.Contains(norm, "chillhop"):
		return "lo-fi"
	case strings.Contains(norm, "focus") || strings.Contains(norm, "study") || strings.Contains(norm, "work"):
		return "deep focus"
	case strings.Contains(norm, "sleep") || strings.Contains(norm, "bedtime") || strings.Contains(norm, "sleeping"):
		return "sleep"
	case strings.Contains(norm, "acoustic") || strings.Contains(norm, "unplugged"):
		return "acoustic"
	case strings.Contains(norm, "party") || strings.Contains(norm, "club") || strings.Contains(norm, "dance"):
		return "party"
	case strings.Contains(norm, "viral") || strings.Contains(norm, "tiktok"):
		return "viral"
	case strings.Contains(norm, "new release") || strings.Contains(norm, "fresh") || strings.Contains(norm, "brand new"):
		return "new release"
	case strings.Contains(norm, "80") || strings.Contains(norm, "eighties"):
		return "80s"
	case strings.Contains(norm, "90") || strings.Contains(norm, "nineties"):
		return "90s"
	case strings.Contains(norm, "rock"):
		return "classic rock"
	case strings.Contains(norm, "indie") || strings.Contains(norm, "punk"):
		return "indie rock"
	default:
		return norm
	}
}

func (r *DeezerRepository) findPlaylistID(ctx context.Context, query string) (int64, error) {
	norm := strings.ToLower(strings.TrimSpace(query))
	for k, v := range curatedPlaylistMap {
		if strings.Contains(norm, k) {
			return v, nil
		}
	}

	escaped := url.QueryEscape(query)
	searchURL := fmt.Sprintf("/search/playlist?q=%s&limit=5", escaped)
	var payload struct {
		Data []struct {
			ID   int64  `json:"id"`
			User struct {
				Name string `json:"name"`
			} `json:"user"`
		} `json:"data"`
	}
	if err := r.fetchJSON(ctx, searchURL, &payload); err != nil || len(payload.Data) == 0 {
		return 0, fmt.Errorf("curated playlist not found: %s", query)
	}

	for _, pl := range payload.Data {
		u := strings.ToLower(pl.User.Name)
		if strings.Contains(u, "deezer") || strings.Contains(u, "editor") || strings.Contains(u, "topsify") || strings.Contains(u, "filtr") {
			return pl.ID, nil
		}
	}
	return payload.Data[0].ID, nil
}

func (r *DeezerRepository) fetchCuratedPlaylistTracks(ctx context.Context, query string, limit, offset int) ([]*domain.Track, error) {
	playlistID, err := r.findPlaylistID(ctx, query)
	if err != nil {
		return nil, err
	}

	tracksURL := fmt.Sprintf("/playlist/%d/tracks?limit=%d&index=%d", playlistID, limit, offset)
	var tracksPayload struct {
		Data []deezerTrackDTO `json:"data"`
	}
	if err := r.fetchJSON(ctx, tracksURL, &tracksPayload); err != nil {
		return nil, err
	}

	tracks := make([]*domain.Track, 0, len(tracksPayload.Data))
	for _, dto := range tracksPayload.Data {
		if dto.Title != "" || dto.TitleShort != "" {
			tracks = append(tracks, mapDeezerTrackToDomain(dto))
		}
	}
	return tracks, nil
}

func filterTracksByExplicit(tracks []*domain.Track, explicit bool) []*domain.Track {
	if explicit {
		return tracks
	}
	filtered := make([]*domain.Track, 0, len(tracks))
	for _, t := range tracks {
		if !t.IsExplicit {
			filtered = append(filtered, t)
		}
	}
	return filtered
}
