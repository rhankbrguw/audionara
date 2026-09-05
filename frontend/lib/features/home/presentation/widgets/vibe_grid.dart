import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/bouncing_widget.dart';
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
          itemBuilder: (context, index) {
            final vibe = vibes[index];
            final color1 = vibe.color1;
            final color2 = vibe.color2;

            return BouncingWidget(
              onTap: () {
                context.push(
                  '/trending/${vibe.name}',
                  extra: TrendingRouteExtra(
                    title: vibe.name,
                    subtitle: 'Curated ${vibe.name} tracks & playlist',
                    badge: 'VIBE',
                    color1: vibe.color1.toARGB32(),
                    color2: vibe.color2.toARGB32(),
                  ),
                );
              },
              child: Container(
                width: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color1, color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.glassBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color1.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.glassOverlay,
                            AppColors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.shadowMedium,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              vibe.icon,
                              color: AppColors.textInverse,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            vibe.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.textInverse,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
