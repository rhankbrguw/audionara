import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../../core/widgets/now_playing_indicator.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';
import '../../domain/entities/custom_playlist_track_entity.dart';
import '../bloc/custom_playlist_bloc.dart';
import '../bloc/custom_playlist_event.dart';

class PlaylistTrackTile extends StatelessWidget {
  final CustomPlaylistTrackEntity track;
  final String playlistId;
  final VoidCallback onTap;

  const PlaylistTrackTile({
    super.key,
    required this.track,
    required this.playlistId,
    required this.onTap,
  });

  bool _isCurrent(PlayerState state) {
    if (state is! PlayerPlaying) return false;
    return state.track.id == track.trackId ||
        (state.track.title == track.title && state.track.artist == track.artist);
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
          borderRadius: BorderRadius.circular(8),
          child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          leading: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: track.coverArt.isNotEmpty
                    ? LazyImage(imageUrl: track.coverArt, width: 48, height: 48, fit: BoxFit.cover)
                    : Container(width: 48, height: 48, color: AppColors.surface),
              ),
              if (isCurrent)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: NowPlayingIndicator(isPlaying: isPlaying, size: 18),
                  ),
                ),
            ],
          ),
          title: Text(
            track.title,
            style: TextStyle(
              color: isCurrent ? AppColors.primary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            track.artist,
            style: TextStyle(
              color: isCurrent ? AppColors.primary.withValues(alpha: 0.8) : AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.textSecondary),
            onPressed: () {
              context.read<CustomPlaylistBloc>().add(
                    RemoveTrackFromCustomPlaylistRequested(
                      playlistId: playlistId,
                      trackId: track.trackId,
                    ),
                  );
            },
          ),
          onTap: onTap,
        ),
      );
      },
    );
  }
}
