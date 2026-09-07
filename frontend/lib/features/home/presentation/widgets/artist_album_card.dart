import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/widgets/interactive_pressable.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../player/domain/entities/album_meta.dart';

class ArtistAlbumCard extends StatelessWidget {
  final AlbumMeta album;
  final double width;

  const ArtistAlbumCard({
    super.key,
    required this.album,
    this.width = 130,
  });

  void _onTap(BuildContext context) {
    context.push(
      '/album/${album.id}',
      extra: AlbumRouteExtra(
        id: album.id,
        coverArt: album.coverArt,
        title: album.title,
        artist: album.artist,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InteractivePressable(
      onTap: () => _onTap(context),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: LazyImage(
                imageUrl: album.coverArt,
                width: width,
                height: width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              album.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatSubtitle(album),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSubtitle(AlbumMeta album) {
    final type = _formatType(album.recordType, album.trackCount);
    if (album.year.isNotEmpty) {
      return '$type • ${album.year}';
    }
    return type;
  }

  String _formatType(String recordType, int trackCount) {
    final lower = recordType.toLowerCase();
    if (lower == 'single' || (trackCount > 0 && trackCount <= 3)) return 'Single';
    if (lower == 'ep' || (trackCount >= 4 && trackCount <= 6)) return 'EP';
    if (lower == 'compile') return 'Compilation';
    return 'Album';
  }
}
