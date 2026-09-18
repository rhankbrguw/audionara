import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../playlist/presentation/bloc/custom_playlist_bloc.dart';
import '../../../playlist/presentation/bloc/custom_playlist_event.dart';
import '../../../playlist/presentation/bloc/custom_playlist_state.dart';
import '../../../playlist/domain/entities/custom_playlist_track_entity.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../../../core/widgets/lazy_image.dart';

void showAddToPlaylistDialog(BuildContext context, dynamic track) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return BlocBuilder<CustomPlaylistBloc, CustomPlaylistState>(
        builder: (context, state) {
          if (state is CustomPlaylistLoading) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (state is CustomPlaylistsLoaded) {
            if (state.playlists.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    PlaylistStrings.noCustomPlaylistsYet,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    PlayerStrings.addToPlaylist,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = state.playlists[index];
                      return ListTile(
                        leading: playlist.coverArtUrl.isNotEmpty
                            ? LazyImage(
                                imageUrl: playlist.coverArtUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.queue_music,
                                color: AppColors.textSecondary,
                              ),
                        title: Text(
                          playlist.name,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        onTap: () {
                          final playlistTrack = CustomPlaylistTrackEntity()
                            ..trackId = track.id
                            ..title = track.title
                            ..artist = track.artist
                            ..streamUrl = track.streamUrl
                            ..coverArt = track.coverArt
                            ..artistId = track.artistId
                            ..albumId = track.albumId;

                          context.read<CustomPlaylistBloc>().add(
                            AddTrackToCustomPlaylistRequested(
                              playlistId: playlist.remoteId,
                              track: playlistTrack,
                            ),
                          );

                          Navigator.pop(ctx);
                          AppSnackbar.show(
                            context,
                            PlaylistStrings.addedToPlaylist(playlist.name),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox(height: 200);
        },
      );
    },
  );
}
