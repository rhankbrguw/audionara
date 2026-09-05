import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/auth_strings.dart';

void showLoginPrompt(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.transparent,
    builder: (context) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          const Text(
            AuthStrings.signInRequired,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textInverse,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AuthStrings.signInRequiredDesc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.textInverse70),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.pop();
                context.push('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                AuthStrings.logInOrSignUp,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textInverse,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              AuthStrings.maybeLater,
              style: TextStyle(color: AppColors.textInverse70),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
