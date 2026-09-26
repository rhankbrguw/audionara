package domain

// TopResultItem represents the highest-confidence predictive search match.
type TopResultItem struct {
	Type       string `json:"type"` // "artist", "album", "song"
	ID         string `json:"id"`
	Title      string `json:"title"`
	Subtitle   string `json:"subtitle"`
	CoverArt   string `json:"cover_art"`
	Artist     string `json:"artist,omitempty"`
	ArtistID   string `json:"artist_id,omitempty"`
	AlbumID    string `json:"album_id,omitempty"`
	DurationMs int    `json:"duration_ms,omitempty"`
	IsExplicit bool   `json:"is_explicit,omitempty"`
}

// SearchResult groups tracks by category for multi-entity search.
type SearchResult struct {
	TopResult *TopResultItem `json:"top_result,omitempty"`
	Songs     []*Track       `json:"songs"`
	Artists   []*Track       `json:"artists"`
	Albums    []*Track       `json:"albums"`
}

