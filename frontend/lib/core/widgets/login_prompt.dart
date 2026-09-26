import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../constants/auth_strings.dart';

void showLoginPrompt(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.transparent,
    isScrollControlled: true,
    builder: (ctx) => const _LoginPromptSheet(),
  );
}

class _LoginPromptSheet extends StatelessWidget {
  const _LoginPromptSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              const SizedBox(height: AppSpacing.sm),
              const Icon(Icons.lock_outline_rounded, size: 36, color: AppColors.primary),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                AuthStrings.signInRequired,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textInverse),
              ),
              const SizedBox(height: 4),
              const Text(
                AuthStrings.signInRequiredDesc,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textInverse70),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildPrimaryButton(context),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(minimumSize: const Size(64, 32), padding: EdgeInsets.zero),
                child: const Text(
                  AuthStrings.maybeLater,
                  style: TextStyle(color: AppColors.textInverse70, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 32,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          context.pop();
          context.push('/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
        child: const Text(
          AuthStrings.logInOrSignUp,
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textInverse),
        ),
      ),
    );
  }
}
