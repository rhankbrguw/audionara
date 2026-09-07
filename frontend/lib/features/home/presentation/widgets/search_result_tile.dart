import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../../core/widgets/now_playing_indicator.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../../../player/presentation/bloc/player_state.dart';
import '../../../player/presentation/widgets/player_settings.dart';

class SearchResultTile extends StatelessWidget {
  final Track track;
  final List<Track> queue;
  final String sectionTitle;
  final ValueChanged<String>? onRecordHistory;

  const SearchResultTile({
    super.key,
    required this.track,
    required this.queue,
    required this.sectionTitle,
    this.onRecordHistory,
  });

  bool _isCurrent(PlayerState state) {
    if (state is! PlayerPlaying) return false;
    return state.track.id == track.id ||
        (state.track.title == track.title && state.track.artist == track.artist);
  }

  String _formatDuration(int ms) {
    if (ms <= 0) return '';
    final total = Duration(milliseconds: ms);
    return '${total.inMinutes}:${total.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  void _handleTap(BuildContext context, bool isAlbum, bool isArtist) {
    if (isAlbum) {
      onRecordHistory?.call(track.title);
      final extra = AlbumRouteExtra(
        id: track.id,
        coverArt: track.coverArt,
        title: track.title,
        artist: track.artist,
      );
      context.push('/album/${track.id}', extra: extra);
    } else if (isArtist) {
      onRecordHistory?.call(track.title);
      context.push('/artist/${track.id}', extra: ArtistRouteExtra(id: track.id, name: track.title, genre: ''));
    } else {
      context.read<PlayerBloc>().add(PlayTrackEvent(track, queue));
      context.push('/player', extra: 'search_$sectionTitle');
    }
  }

  Widget _buildLeading(bool isArtist, bool isCurrent, bool isPlaying) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(isArtist ? 100 : AppRadius.sm),
          child: LazyImage(
            imageUrl: track.coverArt,
            width: AppIconSize.xl,
            height: AppIconSize.xl,
            fit: BoxFit.cover,
            fallbackIcon: isArtist ? Icons.person : Icons.music_note,
          ),
        ),
        if (isCurrent)
          Container(
            width: AppIconSize.xl,
            height: AppIconSize.xl,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(child: NowPlayingIndicator(isPlaying: isPlaying, size: 16)),
          ),
      ],
    );
  }

  Widget _buildSubtitle(bool isAlbum, bool isArtist, bool isCurrent) {
    final showDur = !isAlbum && !isArtist && track.durationMs > 0;
    final dur = showDur ? ' · ${_formatDuration(track.durationMs)}' : '';
    final color = isCurrent ? AppColors.primary.withValues(alpha: 0.8) : AppColors.textSecondary;
    return Text(
      '${track.artist}$dur',
      style: TextStyle(color: color, fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget? _buildTrailing(BuildContext context, bool isAlbum, bool isArtist) {
    if (isAlbum || isArtist) return null;
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
    final isArtist = sectionTitle.toLowerCase().contains('artist');
    final isAlbum = sectionTitle.toLowerCase().contains('album');

    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, curr) =>
          _isCurrent(prev) != _isCurrent(curr) ||
          (curr is PlayerPlaying && _isCurrent(curr) && prev is PlayerPlaying && prev.isPlaying != curr.isPlaying),
      builder: (context, state) {
        final isCurrent = !isArtist && !isAlbum && _isCurrent(state);
        final isPlaying = state is PlayerPlaying && state.isPlaying;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: _buildLeading(isArtist, isCurrent, isPlaying),
          title: Text(
            track.title,
            style: TextStyle(
              color: isCurrent ? AppColors.primary : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: _buildSubtitle(isAlbum, isArtist, isCurrent),
          trailing: _buildTrailing(context, isAlbum, isArtist),
          onTap: () => _handleTap(context, isAlbum, isArtist),
        );
      },
    );
  }
}
