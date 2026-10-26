import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/explicit_badge.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../../core/widgets/now_playing_indicator.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';
import '../../../player/presentation/widgets/player_settings.dart';

class ArtistTrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const ArtistTrackTile({
    super.key,
    required this.track,
    required this.onTap,
  });

  String _formatDuration(int ms) {
    if (ms <= 0) return '';
    final total = Duration(milliseconds: ms);
    final minutes = total.inMinutes;
    final seconds = total.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  bool _isCurrentTrack(PlayerState state) {
    if (state is! PlayerPlaying) return false;
    return state.track.id == track.id ||
        (state.track.title == track.title && state.track.artist == track.artist);
  }

  Widget _buildLeading(bool isCurrent, bool isPlaying) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LazyImage(
            imageUrl: track.coverArt,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        if (isCurrent)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(
              child: NowPlayingIndicator(isPlaying: isPlaying, size: 18),
            ),
          ),
      ],
    );
  }

  Widget _buildTitle(bool isCurrent) {
    return Row(
      children: [
        if (track.isExplicit) const ExplicitBadge(),
        Expanded(
          child: Text(
            track.title,
            style: TextStyle(
              color: isCurrent ? AppColors.primary : AppColors.textPrimary,
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
    final dur = track.durationMs > 0 ? ' · ${_formatDuration(track.durationMs)}' : '';
    return Text(
      '${track.artist}$dur',
      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          _isCurrentTrack(prev) != _isCurrentTrack(curr) ||
          (curr is PlayerPlaying && _isCurrentTrack(curr) && prev is PlayerPlaying && prev.isPlaying != curr.isPlaying),
      builder: (context, state) {
        final isCurrent = _isCurrentTrack(state);
        final isPlaying = state is PlayerPlaying && state.isPlaying;

        return Material(
          color: isCurrent ? AppColors.primary.withValues(alpha: 0.08) : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
            leading: _buildLeading(isCurrent, isPlaying),
            title: _buildTitle(isCurrent),
            subtitle: _buildSubtitle(),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 20),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () => showSettingsBottomSheet(context, track),
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
