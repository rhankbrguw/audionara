import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/track.dart';

class QueueTrackTile extends StatelessWidget {
  final Track track;
  final int index;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const QueueTrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.isPlaying,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: track.coverArt.isNotEmpty
              ? Image.network(
                  track.coverArt,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
        title: Text(
          track.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isPlaying ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isPlaying ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          track.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPlaying)
              const Icon(Icons.equalizer, color: AppColors.primary, size: 22)
            else ...[
              if (onRemove != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                  onPressed: onRemove,
                ),
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle, color: AppColors.textSecondary, size: 20),
              ),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 44,
      height: 44,
      color: AppColors.surface,
      child: const Icon(Icons.music_note, color: AppColors.textSecondary, size: 20),
    );
  }
}
