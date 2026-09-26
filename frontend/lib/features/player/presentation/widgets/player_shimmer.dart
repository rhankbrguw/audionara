import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';

class PlayerShimmer extends StatelessWidget {
  const PlayerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final artSize = (size.width * 0.65).clamp(160.0, 260.0);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.surfaceVariant.withValues(alpha: 0.2),
                highlightColor: AppColors.surface,
                child: Container(
                  width: artSize,
                  height: artSize,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Shimmer.fromColors(
                baseColor: AppColors.surfaceVariant.withValues(alpha: 0.2),
                highlightColor: AppColors.surface,
                child: Container(
                  width: 180,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Shimmer.fromColors(
                baseColor: AppColors.surfaceVariant.withValues(alpha: 0.2),
                highlightColor: AppColors.surface,
                child: Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
