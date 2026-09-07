import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/playlist_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../domain/entities/custom_playlist_entity.dart';
import '../bloc/custom_playlist_bloc.dart';
import '../bloc/custom_playlist_event.dart';
import '../bloc/custom_playlist_state.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../../../player/domain/entities/track.dart';
import '../../../home/presentation/widgets/mini_player.dart';
import '../widgets/playlist_track_list.dart';
import '../widgets/playlist_details_app_bar.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class PlaylistDetailsPage extends StatefulWidget {
  const PlaylistDetailsPage({super.key, required this.playlist});

  final CustomPlaylistEntity playlist;

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomPlaylistBloc>().add(
      FetchCustomPlaylistTracksRequested(playlist: widget.playlist),
    );
  }

  void _playTrack(BuildContext context, int index, List<dynamic> tracks) {
    final domainTracks = tracks
        .map(
          (t) => Track(
            id: t.trackId,
            title: t.title,
            artist: t.artist,
            streamUrl: t.streamUrl,
            coverArt: t.coverArt,
            artistId: t.artistId,
            albumId: t.albumId,
          ),
        )
        .toList();
    context.read<PlayerBloc>().add(
      PlayTrackEvent(domainTracks[index], domainTracks),
    );
    context.push('/player');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<CustomPlaylistBloc, CustomPlaylistState>(
        listener: (context, state) {
          if (state is CustomPlaylistError) {
            ErrorSnackbar.show(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          // Resolve the current playlist — prefer live state over initial prop
          final currentPlaylist = state is CustomPlaylistTracksLoaded
              ? state.playlist
              : widget.playlist;
          final currentTracks = state is CustomPlaylistTracksLoaded
              ? state.tracks
              : [];
          return ResponsiveWrapper(
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomScrollView(
                    slivers: [
                      PlaylistDetailsAppBar(
                        playlist: currentPlaylist,
                        tracks: currentTracks,
                        onPlayTrack: _playTrack,
                        onDelete: _confirmDelete,
                      ),
                      PlaylistTrackList(
                        playlist: currentPlaylist,
                        onPlayTrack: _playTrack,
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MiniPlayer(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, CustomPlaylistEntity playlist) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          PlaylistStrings.deletePlaylist,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          PlaylistStrings.deletePlaylistDesc,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              PlaylistStrings.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CustomPlaylistBloc>().add(
                DeleteCustomPlaylistRequested(playlistId: playlist.remoteId),
              );
              Navigator.pop(ctx);
              context.pop();
              AppSnackbar.showGlobal(PlaylistStrings.playlistDeleted);
            },
            child: const Text(
              PlaylistStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
