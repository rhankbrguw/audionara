import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../domain/entities/custom_playlist_entity.dart';

class PlaylistDetailsAppBar extends StatelessWidget {
  final CustomPlaylistEntity playlist;
  final List<dynamic> tracks;
  final void Function(BuildContext, int, List<dynamic>) onPlayTrack;
  final void Function(BuildContext, CustomPlaylistEntity) onDelete;

  const PlaylistDetailsAppBar({
    super.key,
    required this.playlist,
    required this.tracks,
    required this.onPlayTrack,
    required this.onDelete,
  });

  Widget _buildPlayAllButton(BuildContext context) {
    if (tracks.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        icon: const Icon(Icons.play_arrow_rounded, size: 24),
        label: const Text(
          GeneralStrings.playAll,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        onPressed: () => onPlayTrack(context, 0, tracks),
      ),
    );
  }

  Widget _buildBio() {
    if (playlist.bio.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Text(
        playlist.bio,
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary.withValues(alpha: 0.85),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Positioned(
      bottom: 12,
      left: AppSpacing.md + 4,
      right: AppSpacing.md + 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            playlist.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          _buildBio(),
          if (tracks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm + 2),
            _buildPlayAllButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (playlist.coverArtUrl.isNotEmpty)
          LazyImage(imageUrl: playlist.coverArtUrl, fit: BoxFit.cover)
        else
          Container(color: AppColors.surface),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.transparent,
                AppColors.background.withValues(alpha: 0.8),
                AppColors.background,
              ],
              stops: const [0.2, 0.7, 1.0],
            ),
          ),
        ),
        _buildOverlayContent(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 270,
      pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(background: _buildBackground(context)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
          tooltip: PlaylistStrings.editPlaylist,
          onPressed: () => context.push('/edit-playlist', extra: playlist),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () => onDelete(context, playlist),
        ),
      ],
    );
  }
}
