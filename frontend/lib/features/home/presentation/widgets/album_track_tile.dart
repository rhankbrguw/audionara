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
import '../../../player/presentation/widgets/player_settings.dart';

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

  Widget _buildLeading(bool isCurrent, bool isPlaying, bool canPlay) {
    return SizedBox(
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
    );
  }

  Widget _buildTitle(bool isCurrent, bool canPlay) {
    return Row(
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
    );
  }

  Widget _buildSubtitle() {
    final dur = track.durationMs > 0 ? ' · ${formatDuration(track.durationMs)}' : '';
    return Text(
      '${track.artist}$dur',
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTrailing(BuildContext context, bool canPlay) {
    if (!canPlay) {
      return const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 18);
    }
    return IconButton(
      icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 20),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      onPressed: () => showSettingsBottomSheet(context, track),
    );
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

        return Material(
          color: isCurrent ? AppColors.primary.withValues(alpha: 0.08) : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
            leading: _buildLeading(isCurrent, isPlaying, canPlay),
            title: _buildTitle(isCurrent, canPlay),
            subtitle: _buildSubtitle(),
            trailing: _buildTrailing(context, canPlay),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
