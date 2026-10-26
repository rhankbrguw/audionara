import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../../core/widgets/now_playing_indicator.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';
import '../../../player/presentation/widgets/player_settings.dart';

class TrendingTrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const TrendingTrackTile({
    super.key,
    required this.track,
    required this.onTap,
  });

  String _formatDuration(int ms) {
    if (ms <= 0) return '';
    final total = Duration(milliseconds: ms);
    return '${total.inMinutes}:${total.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  bool _isCurrent(PlayerState state) {
    if (state is! PlayerPlaying) return false;
    return state.track.id == track.id ||
        (state.track.title == track.title && state.track.artist == track.artist);
  }

  Widget _buildLeading(bool isCurrent, bool isPlaying) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LazyImage(
            imageUrl: track.coverArt,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        if (isCurrent)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: NowPlayingIndicator(isPlaying: isPlaying, size: 18),
            ),
          ),
      ],
    );
  }

  Widget _buildSubtitle(bool isCurrent) {
    final dur = track.durationMs > 0 ? ' · ${_formatDuration(track.durationMs)}' : '';
    final color = isCurrent
        ? AppColors.primary.withValues(alpha: 0.8)
        : AppColors.textInverse.withValues(alpha: 0.7);
    return Text(
      '${track.artist}$dur',
      style: TextStyle(color: color, fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTitle(bool isCurrent) {
    return Text(
      track.title,
      style: TextStyle(
        color: isCurrent ? AppColors.primary : AppColors.textInverse,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTrailing(BuildContext context) {
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
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          _isCurrent(prev) != _isCurrent(curr) ||
          (curr is PlayerPlaying && _isCurrent(curr) && prev is PlayerPlaying && prev.isPlaying != curr.isPlaying),
      builder: (context, state) {
        final isCurrent = _isCurrent(state);
        final isPlaying = state is PlayerPlaying && state.isPlaying;

        return Material(
          color: isCurrent ? AppColors.primary.withValues(alpha: 0.08) : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: ListTile(
            leading: _buildLeading(isCurrent, isPlaying),
            title: _buildTitle(isCurrent),
            subtitle: _buildSubtitle(isCurrent),
            trailing: _buildTrailing(context),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
