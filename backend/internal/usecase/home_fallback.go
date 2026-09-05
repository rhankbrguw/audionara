package usecase

import "github.com/user/audionara/backend/internal/domain"

// GetHomeFeedFallback returns pre-baked dynamic feed data.
func (uc *HomeUseCase) GetHomeFeedFallback() *domain.HomeFeed {
	return &domain.HomeFeed{
		TrendingHits: []domain.HomeTrending{
			{Title: "Global Top 50", Subtitle: "The most played tracks globally", Badge: "HOT", Color1: "#1CB5E0", Color2: "#000046"},
			{Title: "Viral 50", Subtitle: "Trending on the internet right now", Badge: "VIRAL", Color1: "#FF416C", Color2: "#FF4B2B"},
			{Title: "New Releases", Subtitle: "Freshly dropped tracks this week", Badge: "NEW", Color1: "#8E2DE2", Color2: "#4A00E0"},
		},
		ExploreVibes: []domain.HomeExploreVibe{
			{Name: "Lo-Fi", Icon: "coffee", Color1: "#F2709C", Color2: "#FF9472"},
			{Name: "Deep Focus", Icon: "headphones", Color1: "#11998E", Color2: "#38EF7D"},
			{Name: "Workout", Icon: "fitness_center", Color1: "#FF416C", Color2: "#FF4B2B"},
			{Name: "Sleep", Icon: "bedtime", Color1: "#141E30", Color2: "#243B55"},
			{Name: "Acoustic", Icon: "music_note", Color1: "#F12711", Color2: "#F5AF19"},
			{Name: "Party", Icon: "celebration", Color1: "#8E2DE2", Color2: "#4A00E0"},
		},
		FavoriteArtists: []domain.HomeArtist{
			{ID: 12246, Name: "Taylor Swift", Picture: "https://cdn-images.dzcdn.net/images/artist/e528e270424103b527f8a27ac625563b/500x500-000000-80-0-0.jpg"},
			{ID: 4050205, Name: "The Weeknd", Picture: "https://cdn-images.dzcdn.net/images/artist/581693b4724a7fcfa754455101e13a44/500x500-000000-80-0-0.jpg"},
			{ID: 384236, Name: "Ed Sheeran", Picture: "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"},
			{ID: 1562681, Name: "Ariana Grande", Picture: "https://cdn-images.dzcdn.net/images/artist/721d8fab84b315502de422b8d0901509/500x500-000000-80-0-0.jpg"},
			{ID: 288166, Name: "Justin Bieber", Picture: "https://cdn-images.dzcdn.net/images/artist/fe097f693cebf1f882e3da79e99e3bf9/500x500-000000-80-0-0.jpg"},
		},
		BaseArtist: "Taylor Swift",
		SimilarArtists: []domain.HomeArtist{
			{ID: 1424, Name: "Selena Gomez", Picture: "https://cdn-images.dzcdn.net/images/artist/11d2179973801f9bb97395ca6e8bb254/500x500-000000-80-0-0.jpg"},
			{ID: 384236, Name: "Ed Sheeran", Picture: "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"},
			{ID: 1562681, Name: "Ariana Grande", Picture: "https://cdn-images.dzcdn.net/images/artist/721d8fab84b315502de422b8d0901509/500x500-000000-80-0-0.jpg"},
			{ID: 10459738, Name: "Olivia Rodrigo", Picture: "https://cdn-images.dzcdn.net/images/artist/f64f43caeb131c93a9037c8657d472c3/500x500-000000-80-0-0.jpg"},
			{ID: 8645062, Name: "Dua Lipa", Picture: "https://cdn-images.dzcdn.net/images/artist/f40398f58b0933758368da28f8045e05/500x500-000000-80-0-0.jpg"},
		},
	}
}
