import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/lazy_image.dart';

class AlbumHeroHeader extends StatelessWidget {
  final String? coverArtUrl;

  const AlbumHeroHeader({super.key, required this.coverArtUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: coverArtUrl != null
            ? _buildHeroCover(coverArtUrl!)
            : Container(color: AppColors.surface),
      ),
    );
  }

  Widget _buildHeroCover(String url) {
    return Stack(
      fit: StackFit.expand,
      children: [
        LazyImage(imageUrl: url, fit: BoxFit.cover),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.transparent, AppColors.background],
            ),
          ),
        ),
      ],
    );
  }
}
