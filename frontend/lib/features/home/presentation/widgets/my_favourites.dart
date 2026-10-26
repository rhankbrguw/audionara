import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../playlist/presentation/bloc/playlist_bloc.dart';
import '../../../playlist/presentation/bloc/playlist_event.dart';
import '../../../playlist/presentation/bloc/playlist_state.dart';
import '../../../playlist/domain/entities/playlist_item.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../../../player/domain/entities/track.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import 'my_favourites_components.dart';

/// Displays the first 5 favourite tracks on the home screen
/// with a "See All" link to the full favourites page.
class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  State<MyFavourites> createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  @override
  void initState() {
    super.initState();
    context.read<PlaylistBloc>().add(LoadFavourites());
  }

  void _playTrack(int index, List<PlaylistItem> items) {
    final tracks = items
        .map(
          (i) => Track(
            id: i.trackId,
            title: i.title,
            artist: i.artist,
            streamUrl: i.streamUrl,
            coverArt: i.coverArt,
            artistId: i.artistId,
            albumId: i.albumId,
          ),
        )
        .toList();
    context.read<PlayerBloc>().add(PlayTrackEvent(tracks[index], tracks));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const UnauthenticatedFavourites();
        }

        return BlocBuilder<PlaylistBloc, PlaylistState>(
          buildWhen: (_, state) =>
              state is PlaylistLoading ||
              state is PlaylistLoaded ||
              state is PlaylistError,
          builder: (context, state) {
            if (state is PlaylistLoading) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: ShimmerListTile(),
                  ),
                  childCount: 3,
                ),
              );
            }

            if (state is PlaylistLoaded) {
              if (state.favourites.isEmpty) {
                return const FavouritesEmptyStateWidget();
              }
              return FavouritesPreviewList(
                items: state.favourites,
                onPlay: _playTrack,
              );
            }

            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        );
      },
    );
  }
}
