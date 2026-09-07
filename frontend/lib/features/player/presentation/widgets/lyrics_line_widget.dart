import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class LyricsLineWidget extends StatelessWidget {
  final dynamic line;
  final bool isActive;
  final bool isPast;
  final VoidCallback onTap;

  const LyricsLineWidget({
    super.key,
    required this.line,
    required this.isActive,
    required this.isPast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          color: AppColors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: isActive ? 22 : 18,
                  color: isActive
                      ? AppColors.textPrimary
                      : (isPast
                          ? AppColors.textSecondary.withValues(alpha: 0.3)
                          : AppColors.textSecondary.withValues(alpha: 0.65)),
                ),
            textAlign: TextAlign.center,
            child: Text(line.text),
          ),
        ),
      ),
    );
  }
}
