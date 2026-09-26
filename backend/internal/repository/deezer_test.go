package repository

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/user/audionara/backend/internal/domain"
)


func TestDeezerRepository_SearchAndArtist(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		switch r.URL.Path {
		case "/search":
			w.Write([]byte(`{"data":[{"id":123,"title":"Harder Better","rank":900000,"artist":{"id":27,"name":"Daft Punk"},"album":{"id":302,"cover_xl":"http://img.jpg"},"preview":"http://prev.mp3","duration":224}]}`))
		case "/artist/27":
			w.Write([]byte(`{"id":27,"name":"Daft Punk","nb_fan":5000000,"nb_album":10,"picture_xl":"http://artist.jpg"}`))
		case "/artist/27/top":
			w.Write([]byte(`{"data":[{"id":123,"title":"Harder Better","artist":{"id":27,"name":"Daft Punk"},"preview":"http://prev.mp3"}]}`))
		case "/artist/27/albums":
			w.Write([]byte(`{"data":[{"id":302,"title":"Discovery","release_date":"2001-03-07","cover_xl":"http://cov.jpg","nb_tracks":14}]}`))
		case "/album/302":
			w.Write([]byte(`{"id":302,"title":"Discovery","release_date":"2001-03-07","label":"Virgin","tracks":{"data":[{"id":123,"title":"One More Time","preview":"http://stream.mp3","duration":320}]}}`))
		default:
			w.Write([]byte(`{}`))
		}
	}))
	defer server.Close()

	repo := NewDeezerRepository(nil)
	repo.baseURL = server.URL

	ctx := context.Background()

	// 1. Test SearchByVibe
	tracks, err := repo.SearchByVibe(ctx, "Daft Punk", 10, 0, true)
	if err != nil || len(tracks) == 0 {
		t.Fatalf("SearchByVibe failed: %v", err)
	}
	if tracks[0].Title != "Harder Better" {
		t.Errorf("expected title 'Harder Better', got '%s'", tracks[0].Title)
	}

	// 2. Test GetAlbumDetail
	album, err := repo.GetAlbumDetail(ctx, "302")
	if err != nil || album == nil || len(album.Tracks) == 0 {
		t.Fatalf("GetAlbumDetail failed: %v", err)
	}
	if album.Meta.Label != "Virgin" {
		t.Errorf("expected label 'Virgin', got '%s'", album.Meta.Label)
	}

	// 3. Test GetArtistDetail
	artist, err := repo.GetArtistDetail(ctx, "27")
	if err != nil || artist == nil {
		t.Fatalf("GetArtistDetail failed: %v", err)
	}
	if artist.Name != "Daft Punk" || artist.FansCount != 5000000 {
		t.Errorf("unexpected artist data: %+v", artist)
	}
}

func TestSelectTopResult(t *testing.T) {
	artists := []*domain.Track{{ID: "1", Title: "Daft Punk", Artist: "Daft Punk"}}
	songs := []*domain.Track{{ID: "101", Title: "One More Time", Artist: "Daft Punk"}}
	albums := []*domain.Track{{ID: "201", Title: "Discovery", Artist: "Daft Punk"}}

	topArtist := selectTopResult("daft punk", songs, artists, albums)
	if topArtist == nil || topArtist.Type != "artist" {
		t.Errorf("expected artist top result, got %+v", topArtist)
	}

	topSong := selectTopResult("one more time", songs, artists, albums)
	if topSong == nil || topSong.Type != "song" {
		t.Errorf("expected song top result, got %+v", topSong)
	}

	topAlbum := selectTopResult("discovery", songs, artists, albums)
	if topAlbum == nil || topAlbum.Type != "album" {
		t.Errorf("expected album top result, got %+v", topAlbum)
	}
}

