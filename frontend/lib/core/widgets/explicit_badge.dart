import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ExplicitBadge extends StatelessWidget {
  const ExplicitBadge({super.key, this.margin = const EdgeInsets.only(right: 6)});

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: const Text(
        'E',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          height: 1.0,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
