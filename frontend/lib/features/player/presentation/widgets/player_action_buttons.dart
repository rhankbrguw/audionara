import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/login_prompt.dart';
import '../../../playlist/presentation/bloc/playlist_bloc.dart';
import '../../../playlist/presentation/bloc/playlist_event.dart';
import '../../../playlist/presentation/bloc/playlist_state.dart';
import '../../../playlist/domain/entities/playlist_item.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../../core/widgets/error_snackbar.dart';
import '../bloc/lyrics_bloc.dart';
import '../bloc/lyrics_event.dart';
import 'lyrics_bottom_sheet.dart';
import '../../domain/entities/track.dart';

class PlayerActionButtons extends StatelessWidget {
  const PlayerActionButtons({super.key, required this.track});

  final dynamic track;

  void _showFeedback(BuildContext context, bool isSaved) {
    final message = isSaved
        ? HomeStrings.addedToFavourites
        : HomeStrings.removedFromFavourites;
    AppSnackbar.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaylistBloc, PlaylistState>(
      listenWhen: (_, current) =>
          current is FavouriteToggled || current is PlaylistError,
      listener: (context, state) {
        if (state is FavouriteToggled && state.trackId == track.id) {
          _showFeedback(context, state.isSaved);
        }
        if (state is PlaylistError) {
          AppSnackbar.show(context, state.message, isError: true);
        }
      },
      buildWhen: (_, current) =>
          current is PlaylistTrackStatus ||
          current is FavouriteToggled ||
          current is PlaylistLoaded,
      builder: (context, state) {
        bool isSaved = false;

        if (state is PlaylistLoaded) {
          isSaved = state.favourites.any((t) => t.trackId == track.id);
        } else if (state is PlaylistTrackStatus && state.trackId == track.id) {
          isSaved = state.isSaved;
        } else if (state is FavouriteToggled && state.trackId == track.id) {
          isSaved = state.isSaved;
        } else {
          final currentState = context.read<PlaylistBloc>().state;
          if (currentState is PlaylistLoaded) {
            isSaved = currentState.favourites.any((t) => t.trackId == track.id);
          } else {
            context.read<PlaylistBloc>().add(
              CheckFavouriteStatus(trackId: track.id),
            );
          }
        }

        return Row(
          children: [
            IconButton(
              tooltip: isSaved
                  ? HomeStrings.removedFromFavourites
                  : HomeStrings.addedToFavourites,
              icon: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? AppColors.primary : AppColors.textSecondary,
                size: 32,
              ),
              onPressed: () {
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  final item = PlaylistItem()
                    ..trackId = track.id
                    ..title = track.title
                    ..artist = track.artist
                    ..coverArt = track.coverArt
                    ..streamUrl = track.streamUrl
                    ..artistId = track.artistId
                    ..albumId = track.albumId
                    ..addedAt = DateTime.now();
                  context.read<PlaylistBloc>().add(
                    ToggleFavouriteStatus(item: item),
                  );
                } else {
                  showLoginPrompt(context);
                }
              },
            ),
            IconButton(
              tooltip: PlayerStrings.lyricsTitle,
              icon: const Icon(
                Icons.lyrics_outlined,
                color: AppColors.textSecondary,
                size: 30,
              ),
              onPressed: () {
                final dur = track is Track ? track.durationMs : 0;
                context.read<LyricsBloc>().add(
                  FetchLyricsRequested(
                    artist: track.artist,
                    title: track.title,
                    durationMs: dur,
                  ),
                );
                showLyricsBottomSheet(context, track);
              },
            ),
          ],
        );
      },
    );
  }
}
