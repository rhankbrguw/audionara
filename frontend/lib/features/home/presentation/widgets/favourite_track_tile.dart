import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/home_strings.dart';
import '../../../../../core/widgets/lazy_image.dart';
import '../../../playlist/domain/entities/playlist_item.dart';

class FavouriteTrackTile extends StatelessWidget {
  const FavouriteTrackTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  final PlaylistItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: item.coverArt.isNotEmpty
            ? LazyImage(
                imageUrl: item.coverArt,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              )
            : _placeholderArt(),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.artist,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite, color: AppColors.primary, size: 22),
        tooltip: HomeStrings.removedFromFavourites,
        onPressed: onRemove,
      ),
      onTap: onTap,
    );
  }

  Widget _placeholderArt() {
    return Container(
      width: 52,
      height: 52,
      color: AppColors.surface,
      child: const Icon(Icons.music_note, color: AppColors.textSecondary),
    );
  }
}
