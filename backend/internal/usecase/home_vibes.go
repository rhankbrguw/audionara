package usecase

import (
	"fmt"

	"github.com/user/audionara/backend/internal/domain"
)

func buildDynamicVibes(artists []domain.HomeArtist, hour int) []domain.HomeExploreVibe {
	if len(artists) == 0 {
		return getTimeBasedVibes(hour)
	}
	vibes := make([]domain.HomeExploreVibe, 0, 6)
	maxArtists := 3
	if len(artists) < maxArtists {
		maxArtists = len(artists)
	}
	for i := 0; i < maxArtists; i++ {
		vibes = append(vibes, resolveUserAffinityVibe(artists[i], i))
	}
	for _, tv := range getTimeBasedVibes(hour) {
		if len(vibes) >= 6 {
			break
		}
		vibes = append(vibes, tv)
	}
	return vibes
}

func resolveUserAffinityVibe(artist domain.HomeArtist, variant int) domain.HomeExploreVibe {
	vibe := matchAffinityVibe(artist, variant)
	vibe.Cover = artist.Picture
	return vibe
}

func matchAffinityVibe(artist domain.HomeArtist, variant int) domain.HomeExploreVibe {
	switch variant {
	case 1:
		return domain.HomeExploreVibe{
			Name:     fmt.Sprintf("%s Radio", artist.Name),
			Subtitle: fmt.Sprintf("Similar sounds and underground artists like %s", artist.Name),
			Icon:     "headphones",
			Color1:   "#8B5CF6",
			Color2:   "#F472B6",
		}
	case 2:
		return domain.HomeExploreVibe{
			Name:     fmt.Sprintf("%s Soundscape", artist.Name),
			Subtitle: fmt.Sprintf("Deep cuts and mood explorations inspired by %s", artist.Name),
			Icon:     "music_note",
			Color1:   "#10B981",
			Color2:   "#3B82F6",
		}
	default:
		return domain.HomeExploreVibe{
			Name:     fmt.Sprintf("%s Mix", artist.Name),
			Subtitle: fmt.Sprintf("Top tracks and sonic inspirations from %s", artist.Name),
			Icon:     "hot",
			Color1:   "#FF416C",
			Color2:   "#FF4B2B",
		}
	}
}

func getTimeBasedVibes(hour int) []domain.HomeExploreVibe {
	if hour >= 5 && hour < 12 {
		return getMorningVibes()
	}
	if hour >= 12 && hour < 17 {
		return getAfternoonVibes()
	}
	if hour >= 17 && hour < 22 {
		return getEveningVibes()
	}
	return getNightVibes()
}

func getMorningVibes() []domain.HomeExploreVibe {
	return []domain.HomeExploreVibe{
		{Name: "Morning Acoustic", Subtitle: "Acoustic melodies and gentle rhythms to start your day", Icon: "music_note", Color1: "#F12711", Color2: "#F5AF19", Cover: "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"},
		{Name: "Upbeat Morning Pop", Subtitle: "Energetic chart-toppers to wake up your rhythm", Icon: "celebration", Color1: "#8E2DE2", Color2: "#4A00E0", Cover: "https://cdn-images.dzcdn.net/images/artist/877872aaf75694f11d53c318700ab2b5/500x500-000000-80-0-0.jpg"},
		{Name: "Lo-Fi Sunrise", Subtitle: "Warm vinyl crackles and soothing morning chillhop", Icon: "coffee", Color1: "#F2709C", Color2: "#FF9472", Cover: "https://cdn-images.dzcdn.net/images/artist/e528e270424103b527f8a27ac625563b/500x500-000000-80-0-0.jpg"},
		{Name: "Indie Chill", Subtitle: "Breezy indie discoveries and relaxed afternoon moods", Icon: "headphones", Color1: "#11998E", Color2: "#38EF7D", Cover: "https://cdn-images.dzcdn.net/images/artist/6c03e4c7c36800897fd468633286db24/500x500-000000-80-0-0.jpg"},
	}
}

func getAfternoonVibes() []domain.HomeExploreVibe {
	return []domain.HomeExploreVibe{
		{Name: "Deep Focus Flow", Subtitle: "Ambient electronic beats designed for deep concentration", Icon: "headphones", Color1: "#11998E", Color2: "#38EF7D", Cover: "https://cdn-images.dzcdn.net/images/artist/638e69b9caaf9f9f3f8826febea7b543/500x500-000000-80-0-0.jpg"},
		{Name: "Electronic Work", Subtitle: "Fast-paced synth rhythms to keep your productivity high", Icon: "celebration", Color1: "#4E54C8", Color2: "#8F94FB", Cover: "https://cdn-images.dzcdn.net/images/artist/877872aaf75694f11d53c318700ab2b5/500x500-000000-80-0-0.jpg"},
		{Name: "Afternoon R&B", Subtitle: "Smooth grooves and soulful vocals for the mid-day session", Icon: "music_note", Color1: "#8E2DE2", Color2: "#F472B6", Cover: "https://cdn-images.dzcdn.net/images/artist/581693b4724a7fcfa754455101e13a44/500x500-000000-80-0-0.jpg"},
		{Name: "Coffeehouse Acoustic", Subtitle: "Intimate singer-songwriter acoustic gems", Icon: "coffee", Color1: "#F12711", Color2: "#F5AF19", Cover: "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"},
	}
}

func getEveningVibes() []domain.HomeExploreVibe {
	return []domain.HomeExploreVibe{
		{Name: "Evening Chill", Subtitle: "Golden hour sounds to decompress and unwind after work", Icon: "sunset", Color1: "#F2709C", Color2: "#FF9472", Cover: "https://cdn-images.dzcdn.net/images/artist/6c03e4c7c36800897fd468633286db24/500x500-000000-80-0-0.jpg"},
		{Name: "Party Anthems", Subtitle: "Floor-filling club bangers and dance hits", Icon: "celebration", Color1: "#8E2DE2", Color2: "#4A00E0", Cover: "https://cdn-images.dzcdn.net/images/artist/877872aaf75694f11d53c318700ab2b5/500x500-000000-80-0-0.jpg"},
		{Name: "Synthwave Drive", Subtitle: "Retro neon 80s beats for open highways", Icon: "directions_car", Color1: "#8A2387", Color2: "#E94057", Cover: "https://cdn-images.dzcdn.net/images/artist/638e69b9caaf9f9f3f8826febea7b543/500x500-000000-80-0-0.jpg"},
		{Name: "Sunset Acoustic", Subtitle: "Twilight strums and gentle mellow ballads", Icon: "coffee", Color1: "#F12711", Color2: "#F5AF19", Cover: "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"},
	}
}

func getNightVibes() []domain.HomeExploreVibe {
	return []domain.HomeExploreVibe{
		{Name: "Night Drive Beats", Subtitle: "Atmospheric synth and basslines tailored for midnight drives", Icon: "directions_car", Color1: "#8A2387", Color2: "#E94057", Cover: "https://cdn-images.dzcdn.net/images/artist/638e69b9caaf9f9f3f8826febea7b543/500x500-000000-80-0-0.jpg"},
		{Name: "Late Night R&B", Subtitle: "Introspective slow jams and velvet nocturnal vocals", Icon: "headphones", Color1: "#6366F1", Color2: "#EC4899", Cover: "https://cdn-images.dzcdn.net/images/artist/581693b4724a7fcfa754455101e13a44/500x500-000000-80-0-0.jpg"},
		{Name: "Dark Synthwave", Subtitle: "Heavy cyberpunk bass and dystopian electronic pulses", Icon: "music_note", Color1: "#0F2027", Color2: "#2C5364", Cover: "https://cdn-images.dzcdn.net/images/artist/b18856da7850c8b8cb10476fefc15657/500x500-000000-80-0-0.jpg"},
		{Name: "Acoustic Nightcap", Subtitle: "Soft whisper vocals and minimalist guitar strums", Icon: "coffee", Color1: "#F12711", Color2: "#F5AF19", Cover: "https://cdn-images.dzcdn.net/images/artist/d6bb84390641d8ae9118228d9544e53d/500x500-000000-80-0-0.jpg"},
	}
}
