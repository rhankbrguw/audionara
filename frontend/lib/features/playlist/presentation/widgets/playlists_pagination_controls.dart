import 'package:flutter/material.dart';
import '../../../../core/constants/playlist_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/interactive_pressable.dart';

class PlaylistsPaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PlaylistsPaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  Widget _buildNavButton({
    required String label,
    required IconData icon,
    required bool isEnabled,
    required bool isTrailing,
    required VoidCallback onTap,
  }) {
    return InteractivePressable(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isTrailing) ...[
                Icon(icon, size: 14, color: AppColors.textPrimary),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isTrailing) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 14, color: AppColors.textPrimary),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavButton(
            label: PlaylistStrings.previousPage,
            icon: Icons.chevron_left_rounded,
            isEnabled: currentPage > 1,
            isTrailing: false,
            onTap: () => onPageChanged(currentPage - 1),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            PlaylistStrings.pageOf(currentPage, totalPages),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _buildNavButton(
            label: PlaylistStrings.nextPage,
            icon: Icons.chevron_right_rounded,
            isEnabled: currentPage < totalPages,
            isTrailing: true,
            onTap: () => onPageChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }
}
