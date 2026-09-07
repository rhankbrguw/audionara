package usecase

import (
	"context"
	"errors"
	"fmt"
	"os/exec"
	"strings"
	"time"
)

// resolveStudioMasterAudio extracts the official studio audio stream URL via yt-dlp.
func resolveStudioMasterAudio(ctx context.Context, artist, title string) (string, error) {
	q := fmt.Sprintf("ytsearch1:%s %s audio", artist, title)
	if streamURL, err := execYtDlp(ctx, q); err == nil && streamURL != "" {
		return streamURL, nil
	}
	return "", errors.New("no studio stream returned from resolver")
}

func execYtDlp(ctx context.Context, query string) (string, error) {
	execCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	cmd := exec.CommandContext(
		execCtx,
		"yt-dlp",
		"--no-warnings",
		"--no-update",
		"--no-playlist",
		"--no-video",
		"-g",
		"-f", "140/251/ba[ext=m4a]/ba",
		query,
	)

	out, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("yt-dlp exec error: %w", err)
	}

	streamURL := strings.TrimSpace(string(out))
	if streamURL == "" {
		return "", errors.New("empty stream output")
	}
	lines := strings.Split(streamURL, "\n")
	return strings.TrimSpace(lines[0]), nil
}
