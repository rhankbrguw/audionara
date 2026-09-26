import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../playlist/domain/entities/playlist_item.dart';
import '../../../playlist/presentation/bloc/playlist_bloc.dart';
import '../../../playlist/presentation/bloc/playlist_event.dart';
import 'favourite_track_row.dart';

class UnauthenticatedFavourites extends StatelessWidget {
  const UnauthenticatedFavourites({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  HomeStrings.saveFavouritesUnauthDesc,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouritesEmptyStateWidget extends StatelessWidget {
  const FavouritesEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite_outline_rounded,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                HomeStrings.noFavouritesDesc,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.transparent,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  minimumSize: const Size(100, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => context.push('/search'),
                icon: const Icon(Icons.explore_outlined, size: 18),
                label: const Text(
                  HomeStrings.exploreMusic,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouritesPreviewList extends StatelessWidget {
  final List<PlaylistItem> items;
  final void Function(int, List<PlaylistItem>) onPlay;

  const FavouritesPreviewList({
    super.key,
    required this.items,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final preview = items.take(4).toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FavouriteTrackRow(
          item: preview[index],
          onTap: () => onPlay(index, preview),
          onRemove: () {
            context.read<PlaylistBloc>().add(
              ToggleFavouriteStatus(item: preview[index]),
            );
            AppSnackbar.show(context, HomeStrings.removedFromFavourites);
          },
        ),
        childCount: preview.length,
      ),
    );
  }
}
