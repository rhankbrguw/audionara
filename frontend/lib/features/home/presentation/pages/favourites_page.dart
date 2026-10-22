import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/home_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../playlist/presentation/bloc/playlist_bloc.dart';
import '../../../playlist/presentation/bloc/playlist_event.dart';
import '../../../playlist/presentation/bloc/playlist_state.dart';
import '../../../playlist/domain/entities/playlist_item.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../../../player/domain/entities/track.dart';
import '../../presentation/widgets/mini_player.dart';
import '../widgets/favourites_page_slivers.dart';
import '../widgets/favourites_track_list.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PlaylistBloc>().add(LoadFavourites());
  }

  void _playTrack(BuildContext context, int index, List<PlaylistItem> items) {
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

  Widget _buildContent(BuildContext context, AuthState authState) {
    if (authState is! AuthAuthenticated) {
      return const FavouritesUnauthenticatedState();
    }

    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoading) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        if (state is PlaylistLoaded) {
          if (state.favourites.isEmpty) {
            return const FavouritesEmptyState();
          }
          return FavouritesTrackList(
            items: state.favourites,
            onPlay: (index) => _playTrack(context, index, state.favourites),
            onRemove: (item) {
              context.read<PlaylistBloc>().add(ToggleFavouriteStatus(item: item));
              AppSnackbar.show(context, HomeStrings.removedFromFavourites);
            },
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<PlaylistBloc, PlaylistState>(
        listenWhen: (_, state) => state is PlaylistError,
        listener: (context, state) {
          if (state is PlaylistError) {
            ErrorSnackbar.show(context, state.message, isError: true);
          }
        },
        child: ResponsiveWrapper(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const FavouritesAppBar(),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) => _buildContent(context, authState),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
              const Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
            ],
          ),
        ),
      ),
    );
  }
}
