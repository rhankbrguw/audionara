import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/bouncing_widget.dart';
import '../../data/repositories/home_repository.dart';

class TrendingHits extends StatelessWidget {
  final List<HomeTrending> hits;

  const TrendingHits({super.key, required this.hits});

  @override
  Widget build(BuildContext context) {
    if (hits.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox(height: 200));
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: hits.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final item = hits[index];
            return Container(
              width: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [item.color1, item.color2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: item.color1.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: BouncingWidget(
                onTap: () {
                  context.push(
                    '/trending/${Uri.encodeComponent(item.title)}',
                    extra: TrendingRouteExtra(
                      title: item.title,
                      subtitle: item.subtitle,
                      badge: item.badge,
                      color1: item.color1.toARGB32(),
                      color2: item.color2.toARGB32(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.glassOverlay,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.badge,
                          style: const TextStyle(
                            color: AppColors.textInverse,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textInverse,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.subtitle,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(
                              color: AppColors.textInverse.withValues(
                                alpha: 0.8,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
