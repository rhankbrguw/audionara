import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../data/repositories/home_repository.dart';

class SearchArtistFisheyeTile extends StatefulWidget {
  final HomeArtist artist;
  final VoidCallback onTap;

  const SearchArtistFisheyeTile({
    super.key,
    required this.artist,
    required this.onTap,
  });

  @override
  State<SearchArtistFisheyeTile> createState() => _SearchArtistFisheyeTileState();
}

class _SearchArtistFisheyeTileState extends State<SearchArtistFisheyeTile> {
  bool _isPressed = false;

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.md),
      color: AppColors.surface,
      border: Border.all(
        color: _isPressed ? AppColors.primary : AppColors.glassOverlay,
        width: _isPressed ? 1.5 : 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(
            alpha: _isPressed ? 0.35 : 0.08,
          ),
          blurRadius: _isPressed ? 10 : 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return ClipOval(
      child: LazyImage(
        imageUrl: widget.artist.picture,
        width: 36,
        height: 36,
        fit: BoxFit.cover,
        fallbackIcon: Icons.person,
      ),
    );
  }

  Widget _buildName() {
    return Expanded(
      child: Text(
        widget.artist.name,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: _buildDecoration(),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: AppSpacing.sm),
          _buildName(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: _buildContent(),
      ),
    );
  }
}
