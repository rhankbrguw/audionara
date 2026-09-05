import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/constants/general_strings.dart';
import '../../../player/domain/entities/album_detail.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';
import 'album_hero_header.dart';
import 'album_metadata_header.dart';
import 'album_track_tile.dart';

class AlbumDetailContent extends StatelessWidget {
  final AlbumDetail album;
  final Function(Track, List<Track>) onPlayTrack;
  final String Function(int) formatDuration;
  final String Function(int) formatTrackDuration;

  const AlbumDetailContent({
    super.key,
    required this.album,
    required this.onPlayTrack,
    required this.formatDuration,
    required this.formatTrackDuration,
  });

  @override
  Widget build(BuildContext context) {
    final playableQueue =
        album.tracks.where((t) => t.streamUrl.isNotEmpty).toList();

    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        final hasMiniPlayer = state is PlayerPlaying || state is PlayerLoading;
        final bottomInset = MediaQuery.of(context).padding.bottom;
        final compactBottom = (bottomInset * 0.35).clamp(0.0, 8.0);
        final bottomPadding = hasMiniPlayer
            ? (54.0 + compactBottom + AppSpacing.lg)
            : (AppSpacing.xl + bottomInset);

        return CustomScrollView(
          slivers: [
            AlbumHeroHeader(coverArtUrl: album.meta.coverArt),
            AlbumMetadataHeader(
              album: album,
              playableQueue: playableQueue,
              onPlayAll: () => onPlayTrack(playableQueue.first, playableQueue),
            ),
            SliverList(
              key: ValueKey('album_tracks_${album.meta.id}'),
              delegate: SliverChildBuilderDelegate(
                (context, i) => AlbumTrackTile(
                  track: album.tracks[i],
                  index: i + 1,
                  onTap: album.tracks[i].streamUrl.isNotEmpty
                      ? () => onPlayTrack(album.tracks[i], playableQueue)
                      : null,
                  formatDuration: formatTrackDuration,
                ),
                childCount: album.tracks.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    GeneralStrings.albumTracksDuration(
                      album.tracks.length,
                      formatDuration(album.totalDurationMs),
                    ),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: bottomPadding)),
          ],
        );
      },
    );
  }
}
