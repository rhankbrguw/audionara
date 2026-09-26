package usecase

// defaultGenres is the global fallback seed pool when the user has no history.
// These are normalized genre names aligned with the iTunes Search API taxonomy.
var defaultGenres = []string{
	"pop", "rock", "hip hop", "jazz", "electronic",
	"classical", "rnb", "indie", "synthwave", "alternative",
}

// timeOfDayVibes returns genre seeds appropriate for the current hour of day.
// This creates a natural listening arc across the day.
func timeOfDayVibes(hour int) []string {
	switch {
	case hour >= 5 && hour < 10:
		// Morning: upbeat, energetic start
		return []string{"pop", "indie", "alternative"}
	case hour >= 10 && hour < 14:
		// Midday: focused, productive
		return []string{"electronic", "jazz", "classical"}
	case hour >= 14 && hour < 18:
		// Afternoon: mixed energy
		return []string{"rock", "hip hop", "rnb"}
	case hour >= 18 && hour < 22:
		// Evening: social, upbeat
		return []string{"pop", "rock", "electronic"}
	default:
		// Late night: chill, mellow
		return []string{"jazz", "classical", "synthwave"}
	}
}

// djArcVibes splits a session into 3 energy phases (warm-up, peak, wind-down).
// Each phase gets a different vibe so the listening experience feels curated,
// not randomly shuffled.
func djArcVibes(topVibes []string, fallback []string) (warmUp, peak, windDown string) {
	pool := topVibes
	if len(pool) == 0 {
		pool = fallback
	}

	// Deterministically assign roles based on pool ordering
	if len(pool) >= 3 {
		return pool[1], pool[0], pool[2] // peak = highest weighted
	}
	if len(pool) == 2 {
		return pool[1], pool[0], pool[1]
	}
	return pool[0], pool[0], pool[0]
}
