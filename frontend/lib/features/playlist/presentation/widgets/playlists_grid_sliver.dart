import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../home/presentation/widgets/custom_playlist_card.dart';

class PlaylistsGridSliver extends StatelessWidget {
  const PlaylistsGridSliver({super.key, required this.pageItems});

  final List<dynamic> pageItems;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => CustomPlaylistCard(playlist: pageItems[index]),
          childCount: pageItems.length,
        ),
      ),
    );
  }
}
