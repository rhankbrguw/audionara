import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/general_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/explicit_badge.dart';
import '../../../../core/widgets/now_playing_indicator.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';

class AlbumTrackTile extends StatelessWidget {
  final Track track;
  final int index;
  final VoidCallback? onTap;
  final String Function(int) formatDuration;

  const AlbumTrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.onTap,
    required this.formatDuration,
  });

  bool _isCurrentTrack(PlayerState state) {
    if (state is! PlayerPlaying) return false;
    return state.track.id == track.id ||
        (state.track.title == track.title && state.track.artist == track.artist);
  }

  @override
  Widget build(BuildContext context) {
    final canPlay = onTap != null;
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          _isCurrentTrack(prev) != _isCurrentTrack(curr) ||
          (curr is PlayerPlaying && _isCurrentTrack(curr) && prev is PlayerPlaying && prev.isPlaying != curr.isPlaying),
      builder: (context, playerState) {
        final isCurrent = _isCurrentTrack(playerState);
        final isPlaying = playerState is PlayerPlaying && playerState.isPlaying;

        return ListTile(
          tileColor: isCurrent ? AppColors.primary.withValues(alpha: 0.08) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 2,
          ),
          leading: SizedBox(
            width: 32,
            child: Center(
              child: isCurrent
                  ? NowPlayingIndicator(isPlaying: isPlaying, size: 16)
                  : Text(
                      GeneralStrings.trackIndex(index),
                      style: TextStyle(
                        color: canPlay
                            ? AppColors.textSecondary
                            : AppColors.textSecondary.withValues(alpha: 0.3),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          title: Row(
            children: [
              if (track.isExplicit) const ExplicitBadge(),
              Expanded(
                child: Text(
                  track.title,
                  style: TextStyle(
                    color: isCurrent
                        ? AppColors.primary
                        : canPlay
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: canPlay
              ? (track.durationMs > 0
                  ? Text(
                      formatDuration(track.durationMs),
                      style: TextStyle(
                        color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    )
                  : null)
              : const Icon(
                  Icons.lock_outline,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
          onTap: onTap,
        );
      },
    );
  }
}
