import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/constants/general_strings.dart';
import '../../../../core/constants/home_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/bouncing_widget.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../data/repositories/home_repository.dart';

class VibeGrid extends StatelessWidget {
  final List<HomeExploreVibe> vibes;

  const VibeGrid({super.key, required this.vibes});

  @override
  Widget build(BuildContext context) {
    if (vibes.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox(height: 120));
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: vibes.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) => _buildCard(context, vibes[index]),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, HomeExploreVibe vibe) {
    return BouncingWidget(
      onTap: () => _navigateToVibe(context, vibe),
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: vibe.color1.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (vibe.cover.isNotEmpty)
                LazyImage(imageUrl: vibe.cover, fit: BoxFit.cover),
              _buildGradientOverlay(vibe),
              _buildCardContent(context, vibe),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToVibe(BuildContext context, HomeExploreVibe vibe) {
    final sub = vibe.subtitle.isNotEmpty
        ? vibe.subtitle
        : GeneralStrings.defaultVibeSubtitle(vibe.name);
    context.push(
      '/trending/${vibe.name}',
      extra: TrendingRouteExtra(
        title: vibe.name,
        subtitle: sub,
        badge: HomeStrings.vibeBadge,
        color1: vibe.color1.toARGB32(),
        color2: vibe.color2.toARGB32(),
        cover: vibe.cover,
      ),
    );
  }

  Widget _buildGradientOverlay(HomeExploreVibe vibe) {
    final hasCover = vibe.cover.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: hasCover
              ? [vibe.color1.withValues(alpha: 0.35), AppColors.background.withValues(alpha: 0.88)]
              : [vibe.color1, vibe.color2],
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, HomeExploreVibe vibe) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          vibe.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
        ),
      ),
    );
  }
}
