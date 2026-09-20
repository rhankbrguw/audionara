import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/playlist_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../home/presentation/widgets/mini_player.dart';
import '../bloc/custom_playlist_bloc.dart';
import '../bloc/custom_playlist_state.dart';
import '../bloc/custom_playlist_event.dart';
import '../widgets/playlists_grid_sliver.dart';
import '../widgets/playlists_page_slivers.dart';
import '../widgets/playlists_pagination_controls.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  static const int _pageSize = 6;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<CustomPlaylistBloc>().add(FetchCustomPlaylistsRequested());
  }

  Widget _buildAppBar(BuildContext context, AuthState authState) {
    final isAuth = authState is AuthAuthenticated;
    return SliverAppBar(
      backgroundColor: AppColors.background,
      pinned: true,
      elevation: 0,
      title: const Text(
        PlaylistStrings.allPlaylists,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: isAuth
          ? [
              IconButton(
                icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                onPressed: () => context.push('/create-playlist'),
              ),
            ]
          : null,
    );
  }

  Widget _buildGrid(List<dynamic> playlists) {
    final totalPages = (playlists.length / _pageSize).ceil();
    final clampedPage = _currentPage.clamp(1, totalPages > 0 ? totalPages : 1);
    final startIndex = (clampedPage - 1) * _pageSize;
    final pageItems = playlists.skip(startIndex).take(_pageSize).toList();
    return PlaylistsGridSliver(pageItems: pageItems);
  }

  Widget _buildBody(BuildContext context, AuthState authState) {
    if (authState is! AuthAuthenticated) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, authState),
          const PlaylistsUnauthenticatedState(),
        ],
      );
    }

    return BlocBuilder<CustomPlaylistBloc, CustomPlaylistState>(
      builder: (context, state) {
        if (state is CustomPlaylistLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is CustomPlaylistsLoaded) {
          if (state.playlists.isEmpty) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context, authState),
                const PlaylistsEmptyState(),
              ],
            );
          }
          final totalPages = (state.playlists.length / _pageSize).ceil();
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, authState),
              _buildGrid(state.playlists),
              SliverToBoxAdapter(
                child: PlaylistsPaginationControls(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  onPageChanged: (p) => setState(() => _currentPage = p),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            Positioned.fill(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) => _buildBody(context, authState),
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
      ),
    );
  }
}
