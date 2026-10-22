import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/lazy_image.dart';

class PlayerArt extends StatelessWidget {
  final String coverArtUrl;
  final String trackId;

  const PlayerArt({
    super.key,
    required this.coverArtUrl,
    required this.trackId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate the most appropriate size based on device layout
    // Desktop/Tablet landscape will naturally restrict it via Flex/Expanded
    // Mobile will use available height but cap width to not touch edges
    final maxSize = screenWidth > 768 ? 500.0 : screenWidth * 0.9;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxSize, 
        maxWidth: maxSize,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: coverArtUrl.isNotEmpty
              ? Hero(
                  tag: 'album_art_$trackId',
                  child: LazyImage(imageUrl: coverArtUrl, fit: BoxFit.cover),
                )
              : _buildFallbackArt(),
        ),
      ),
    );
  }

  Widget _buildFallbackArt() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.music_note, size: 80, color: AppColors.textSecondary),
      ),
    );
  }
}
