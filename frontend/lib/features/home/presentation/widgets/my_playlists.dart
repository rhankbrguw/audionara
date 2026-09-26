import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../playlist/presentation/bloc/custom_playlist_bloc.dart';
import '../../../playlist/presentation/bloc/custom_playlist_state.dart';
import '../../../playlist/presentation/bloc/custom_playlist_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import 'unauthenticated_playlists_view.dart';
import 'empty_playlists_view.dart';
import 'create_playlist_card.dart';
import 'custom_playlist_card.dart';

class MyPlaylists extends StatefulWidget {
  const MyPlaylists({super.key});

  @override
  State<MyPlaylists> createState() => _MyPlaylistsState();
}

class _MyPlaylistsState extends State<MyPlaylists> {
  @override
  void initState() {
    super.initState();
    context.read<CustomPlaylistBloc>().add(FetchCustomPlaylistsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const UnauthenticatedPlaylistsView();
        }

        return BlocBuilder<CustomPlaylistBloc, CustomPlaylistState>(
          builder: (context, state) {
            if (state is CustomPlaylistLoading) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 155,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => const ShimmerCard(width: 120, height: 155),
                  ),
                ),
              );
            }

            if (state is CustomPlaylistsLoaded) {
              if (state.playlists.isEmpty) {
                return const EmptyPlaylistsView();
              }

              final preview = state.playlists.take(3).toList();
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 155,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    scrollDirection: Axis.horizontal,
                    itemCount: preview.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const CreatePlaylistCard();
                      }

                      final playlist = preview[index - 1];
                      return CustomPlaylistCard(playlist: playlist, width: 120);
                    },
                  ),
                ),
              );
            }

            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        );
      },
    );
  }
}
