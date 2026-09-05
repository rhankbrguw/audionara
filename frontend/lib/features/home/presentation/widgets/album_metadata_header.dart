import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/widgets/interactive_pressable.dart';
import '../../../player/domain/entities/album_detail.dart';
import '../../../player/domain/entities/track.dart';

class AlbumMetadataHeader extends StatelessWidget {
  final AlbumDetail album;
  final List<Track> playableQueue;
  final VoidCallback onPlayAll;

  const AlbumMetadataHeader({
    super.key,
    required this.album,
    required this.playableQueue,
    required this.onPlayAll,
  });

  void _navigateToArtist(BuildContext context) {
    final id = album.meta.artistId.isNotEmpty ? album.meta.artistId : album.meta.artist;
    context.push(
      '/artist/$id',
      extra: ArtistRouteExtra(
        id: id,
        name: album.meta.artist,
        genre: album.meta.genre,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              album.meta.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            InteractivePressable(
              onTap: () => _navigateToArtist(context),
              child: Text(
                album.meta.artist,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildMetaChips(),
            const SizedBox(height: AppSpacing.md),
            if (playableQueue.isNotEmpty)
              InteractivePressable(
                onTap: onPlayAll,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, color: AppColors.onPrimary),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        GeneralStrings.playAll,
                        style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.surface),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChips() {
    final recordTypeLabel = _formatRecordType(album.meta.recordType, album.meta.trackCount);
    final chips = <Widget>[
      _buildPill(Icons.album_outlined, recordTypeLabel),
      if (album.meta.label.isNotEmpty) _buildPill(Icons.business_rounded, album.meta.label),
      if (album.meta.genre.isNotEmpty) _buildPill(Icons.music_note_rounded, album.meta.genre),
    ];
    return Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: chips);
  }

  String _formatRecordType(String recordType, int trackCount) {
    final lower = recordType.toLowerCase();
    if (lower == 'single' || (trackCount > 0 && trackCount <= 3)) return 'Single';
    if (lower == 'ep' || (trackCount >= 4 && trackCount <= 6)) return 'EP';
    if (lower == 'compile' || lower.contains('compilation')) return 'Compilation';
    return 'Album';
  }

  Widget _buildPill(IconData icon, String text) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.accent),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
