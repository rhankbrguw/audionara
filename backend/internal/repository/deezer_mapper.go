package repository

import (
	"strconv"
	"strings"

	"github.com/user/audionara/backend/internal/domain"
)

type deezerTrackDTO struct {
	ID             int64           `json:"id"`
	Title          string          `json:"title"`
	TitleShort     string          `json:"title_short"`
	Duration       int             `json:"duration"`
	TrackNumber    int             `json:"track_position"`
	Preview        string          `json:"preview"`
	Rank           int             `json:"rank"`
	ExplicitLyrics bool            `json:"explicit_lyrics"`
	Artist         deezerArtistDTO `json:"artist"`
	Album          deezerAlbumDTO  `json:"album"`
}

type deezerArtistDTO struct {
	ID            int64  `json:"id"`
	Name          string `json:"name"`
	Picture       string `json:"picture"`
	PictureMedium string `json:"picture_medium"`
	PictureBig    string `json:"picture_big"`
	PictureXL     string `json:"picture_xl"`
	NbFan         int    `json:"nb_fan"`
	NbAlbum       int    `json:"nb_album"`
}

type deezerAlbumDTO struct {
	ID          int64             `json:"id"`
	Title       string            `json:"title"`
	Cover       string            `json:"cover"`
	CoverMedium string            `json:"cover_medium"`
	CoverBig    string            `json:"cover_big"`
	CoverXL     string            `json:"cover_xl"`
	ReleaseDate string            `json:"release_date"`
	RecordType  string            `json:"record_type"`
	Type        string            `json:"type"`
	Label       string            `json:"label"`
	TrackCount  int               `json:"nb_tracks"`
	Artist      deezerArtistDTO   `json:"artist"`
	Tracks      deezerTrackList   `json:"tracks"`
	Genres      deezerGenreObject `json:"genres"`
}

type deezerTrackList struct {
	Data []deezerTrackDTO `json:"data"`
}

type deezerGenreObject struct {
	Data []struct {
		Name string `json:"name"`
	} `json:"data"`
}

func mapDeezerTrackToDomain(dto deezerTrackDTO) *domain.Track {
	cover := pickBestArtwork(dto.Album.CoverXL, dto.Album.CoverBig, dto.Album.CoverMedium, dto.Album.Cover)
	if cover == "" {
		cover = pickBestArtwork(dto.Artist.PictureXL, dto.Artist.PictureBig, dto.Artist.PictureMedium, dto.Artist.Picture)
	}

	title := dto.Title
	if title == "" {
		title = dto.TitleShort
	}

	return &domain.Track{
		ID:          strconv.FormatInt(dto.ID, 10),
		Title:       title,
		Artist:      dto.Artist.Name,
		StreamURL:   dto.Preview,
		CoverArt:    cover,
		DurationMs:  dto.Duration * 1000,
		TrackNumber: dto.TrackNumber,
		AlbumID:     formatInt64(dto.Album.ID),
		ArtistID:    formatInt64(dto.Artist.ID),
		IsExplicit:  dto.ExplicitLyrics,
	}
}

func resolveReleaseYear(date string) string {
	if len(date) >= 4 {
		return date[:4]
	}
	return ""
}

func resolveRecordType(dto deezerAlbumDTO) string {
	if dto.RecordType != "" {
		return strings.ToLower(dto.RecordType)
	}
	if dto.Type != "" && dto.Type != "album" {
		return strings.ToLower(dto.Type)
	}
	if dto.TrackCount > 0 && dto.TrackCount <= 3 {
		return "single"
	}
	if dto.TrackCount >= 4 && dto.TrackCount <= 6 {
		return "ep"
	}
	return "album"
}

func mapDeezerAlbumToMeta(dto deezerAlbumDTO) *domain.AlbumMeta {
	genre := ""
	if len(dto.Genres.Data) > 0 {
		genre = dto.Genres.Data[0].Name
	}
	cover := pickBestArtwork(dto.CoverXL, dto.CoverBig, dto.CoverMedium, dto.Cover)

	return &domain.AlbumMeta{
		ID:          strconv.FormatInt(dto.ID, 10),
		Title:       dto.Title,
		Artist:      dto.Artist.Name,
		ArtistID:    formatInt64(dto.Artist.ID),
		CoverArt:    cover,
		Genre:       genre,
		Year:        resolveReleaseYear(dto.ReleaseDate),
		TrackCount:  dto.TrackCount,
		Label:       dto.Label,
		ReleaseDate: dto.ReleaseDate,
		RecordType:  resolveRecordType(dto),
	}
}

func pickBestArtwork(candidates ...string) string {
	for _, c := range candidates {
		if c != "" {
			return c
		}
	}
	return ""
}

func formatInt64(id int64) string {
	if id == 0 {
		return ""
	}
	return strconv.FormatInt(id, 10)
}
