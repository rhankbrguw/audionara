import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/interactive_pressable.dart';
import '../../data/repositories/home_feed_models.dart';

class FavoriteArtistsSection extends StatelessWidget {
  final List<HomeArtist> artists;

  const FavoriteArtistsSection({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    final displayArtists = artists.take(5).toList();
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 140,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: displayArtists.length,
          separatorBuilder: (_, __) => const SizedBox(width: 18),
          itemBuilder: (context, index) => FisheyeArtistCard(artist: displayArtists[index]),
        ),
      ),
    );
  }
}

class FisheyeArtistCard extends StatelessWidget {
  final HomeArtist artist;

  const FisheyeArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return InteractivePressable(
      onTap: () {
        if (artist.id > 0) context.push('/artist/${artist.id}');
      },
      child: SizedBox(
        width: 88,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFisheyeAvatar(),
            const SizedBox(height: 8),
            _buildArtistName(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFisheyeAvatar() {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary.withValues(alpha: 0.6), AppColors.surfaceVariant],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.5),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [_buildArtistImage(), _buildFisheyeGlass()],
          ),
        ),
      ),
    );
  }

  Widget _buildArtistImage() {
    if (artist.picture.isEmpty) {
      return Container(
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.person, color: AppColors.textSecondary, size: 36),
      );
    }
    return CachedNetworkImage(
      imageUrl: artist.picture,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: AppColors.surfaceVariant),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.person, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildFisheyeGlass() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.4),
          radius: 0.85,
          colors: [
            AppColors.onPrimary.withValues(alpha: 0.35),
            AppColors.transparent,
            AppColors.shadowMedium,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }

  Widget _buildArtistName(BuildContext context) {
    return Text(
      artist.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
    );
  }
}
