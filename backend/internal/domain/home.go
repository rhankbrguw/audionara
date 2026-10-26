package domain

// HomeTrending represents a trending hit section on the home screen.
type HomeTrending struct {
	Title    string `json:"title"`
	Subtitle string `json:"subtitle"`
	Badge    string `json:"badge"`
	Color1   string `json:"color1"`
	Color2   string `json:"color2"`
}

// HomeExploreVibe represents an explore vibe section on the home screen.
type HomeExploreVibe struct {
	Name     string `json:"name"`
	Subtitle string `json:"subtitle,omitempty"`
	Icon     string `json:"icon"`
	Color1   string `json:"color1"`
	Color2   string `json:"color2"`
	Cover    string `json:"cover,omitempty"`
}

// HomeArtist represents a curated/top artist in the home feed.
type HomeArtist struct {
	ID      int64  `json:"id"`
	Name    string `json:"name"`
	Picture string `json:"picture"`
}

// HomeFeed represents the dynamic layout of the home screen.
type HomeFeed struct {
	TrendingHits    []HomeTrending    `json:"trending_hits"`
	ExploreVibes    []HomeExploreVibe `json:"explore_vibes"`
	FavoriteArtists []HomeArtist      `json:"favorite_artists"`
	BaseArtist      string            `json:"base_artist"`
	SimilarArtists  []HomeArtist      `json:"similar_artists"`
}
