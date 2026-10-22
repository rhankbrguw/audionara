package usecase

import (
	"strings"
)

func mapGenreToRelated(vibe string) string {
	switch {
	case strings.Contains(vibe, "rock"):
		return "indie rock"
	case strings.Contains(vibe, "pop"):
		return "dance pop"
	case strings.Contains(vibe, "hip hop") || strings.Contains(vibe, "rap"):
		return "rnb"
	case strings.Contains(vibe, "jazz"):
		return "blues"
	case strings.Contains(vibe, "electronic") || strings.Contains(vibe, "edm"):
		return "house"
	case strings.Contains(vibe, "classical"):
		return "ambient"
	default:
		return vibe + " mix"
	}
}

func applyPenaltyShift(vibe, related string) string {
	vibeMu.RLock()
	weight := vibeWeights[related]
	vibeMu.RUnlock()

	if weight >= 0 {
		return related
	}
	switch {
	case strings.Contains(vibe, "rock"):
		return "alternative"
	case strings.Contains(vibe, "pop"):
		return "acoustic pop"
	default:
		return vibe + " top tracks"
	}
}

// getRelatedVibe dynamically maps a genre to a related sub-genre.
func getRelatedVibe(vibe string) string {
	vibe = strings.ToLower(vibe)
	related := mapGenreToRelated(vibe)
	return applyPenaltyShift(vibe, related)
}
