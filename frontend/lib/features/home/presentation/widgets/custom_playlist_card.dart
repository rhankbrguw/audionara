import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/lazy_image.dart';

class CustomPlaylistCard extends StatelessWidget {
  final dynamic playlist;
  final double? width;

  const CustomPlaylistCard({
    super.key,
    required this.playlist,
    this.width,
  });

  Widget _buildArt() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: AppColors.surface,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: playlist.coverArtUrl.isNotEmpty
              ? LazyImage(
                  imageUrl: playlist.coverArtUrl,
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: Icon(
                    Icons.music_note,
                    color: AppColors.textSecondary,
                    size: 36,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/playlist/${playlist.remoteId}', extra: playlist),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildArt(),
            const SizedBox(height: AppSpacing.xs + 2),
            Text(
              playlist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
