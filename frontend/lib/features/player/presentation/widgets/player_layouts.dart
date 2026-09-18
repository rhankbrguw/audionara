import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_state.dart';
import 'player_art.dart';
import 'player_header_info.dart';
import 'player_slider.dart';
import 'player_controls.dart';
import 'player_settings.dart';
import 'quality_badge.dart';

class PlayerDesktopLayout extends StatelessWidget {
  const PlayerDesktopLayout({super.key, required this.state});
  final PlayerPlaying state;

  @override
  Widget build(BuildContext context) {
    final track = state.track;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: PlayerArt(
                  coverArtUrl: track.coverArt,
                  trackId: track.id,
                ),
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const QualityBadge(),
                  PlayerHeaderInfo(track: track),
                  const SizedBox(height: 48),
                  PlayerSlider(state: state),
                  const SizedBox(height: 2),
                  PlayerTimeRow(state: state),
                  const SizedBox(height: 16),
                  PlayerControls(
                    state: state,
                    onSettingsTap: () => showSettingsBottomSheet(context, track),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerMobileLayout extends StatelessWidget {
  const PlayerMobileLayout({
    super.key,
    required this.state,
    required this.constraints,
  });

  final PlayerPlaying state;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final track = state.track;
    final isVerySmall = constraints.maxHeight < 650;

    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: PlayerArt(
                  coverArtUrl: track.coverArt,
                  trackId: track.id,
                ),
              ),
            ),
            SizedBox(height: isVerySmall ? 16 : 32),
            const QualityBadge(),
            PlayerHeaderInfo(track: track),
            SizedBox(height: isVerySmall ? 16 : 24),
            PlayerSlider(state: state),
            const SizedBox(height: 2),
            PlayerTimeRow(state: state),
            SizedBox(height: isVerySmall ? 4 : 8),
            PlayerControls(
              state: state,
              onSettingsTap: () => showSettingsBottomSheet(context, track),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class PlayerTimeRow extends StatelessWidget {
  const PlayerTimeRow({super.key, required this.state});
  final PlayerPlaying state;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = state.duration.inMilliseconds > 0
        ? state.duration
        : (state.track.durationMs > 0 ? Duration(milliseconds: state.track.durationMs) : Duration.zero);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDuration(state.position),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          _formatDuration(totalDuration),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
