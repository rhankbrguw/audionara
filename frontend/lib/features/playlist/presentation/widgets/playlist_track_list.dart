import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/playlist_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/custom_playlist_entity.dart';
import '../bloc/custom_playlist_bloc.dart';
import '../bloc/custom_playlist_state.dart';
import 'playlist_track_tile.dart';

class PlaylistTrackList extends StatelessWidget {
  final CustomPlaylistEntity playlist;
  final Function(BuildContext, int, List<dynamic>) onPlayTrack;

  const PlaylistTrackList({
    super.key,
    required this.playlist,
    required this.onPlayTrack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomPlaylistBloc, CustomPlaylistState>(
      builder: (context, state) {
        if (state is CustomPlaylistLoading) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            ),
          );
        }

        if (state is CustomPlaylistTracksLoaded && state.playlist.remoteId == playlist.remoteId) {
          if (state.tracks.isEmpty) {
            return const SliverToBoxAdapter(child: _EmptyPlaylistView());
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final track = state.tracks[index];
              return PlaylistTrackTile(
                track: track,
                playlistId: playlist.remoteId,
                onTap: () => onPlayTrack(context, index, state.tracks),
              );
            }, childCount: state.tracks.length),
          );
        }

        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: Center(
              child: Text(PlaylistStrings.failedToLoadTracks, style: TextStyle(color: AppColors.error)),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyPlaylistView extends StatelessWidget {
  const _EmptyPlaylistView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(PlaylistStrings.noTracksYet, style: TextStyle(color: AppColors.textSecondary, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
