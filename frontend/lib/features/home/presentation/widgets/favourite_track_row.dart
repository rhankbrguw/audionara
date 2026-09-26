import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/interactive_pressable.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../playlist/domain/entities/playlist_item.dart';

class FavouriteTrackRow extends StatelessWidget {
  final PlaylistItem item;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const FavouriteTrackRow({
    super.key,
    required this.item,
    required this.onTap,
    this.onRemove,
  });

  Widget _placeholderArt() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        color: AppColors.textSecondary,
        size: 18,
      ),
    );
  }

  Widget _buildArt() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: item.coverArt.isNotEmpty
          ? LazyImage(
              imageUrl: item.coverArt,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
            )
          : _placeholderArt(),
    );
  }

  Widget _buildInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.artist,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHeart() {
    return InteractivePressable(
      onTap: onRemove,
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.xs),
        child: Icon(
          Icons.favorite_rounded,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 3),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            child: Row(
              children: [
                _buildArt(),
                const SizedBox(width: AppSpacing.sm + 4),
                _buildInfo(),
                const SizedBox(width: AppSpacing.sm),
                _buildHeart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
