package domain

// ArtistDetail contains rich metadata about an artist including bio and history.
type ArtistDetail struct {
	ID         string       `json:"id"`
	Name       string       `json:"name"`
	Picture    string       `json:"picture"`
	Bio        string       `json:"bio"`
	History    string       `json:"history"`
	FansCount  int          `json:"fans_count"`
	AlbumCount int          `json:"album_count"`
	Genres     []string     `json:"genres"`
	TopTracks  []*Track     `json:"top_tracks"`
	Albums     []*AlbumMeta `json:"albums"`
}
