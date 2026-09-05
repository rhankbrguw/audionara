import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppSnackbar {
  static void showError(BuildContext context, String message) {
    show(context, message, isError: true);
  }

  static void showGlobal(String message, {bool isError = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = rootScaffoldMessengerKey.currentState;
      if (state != null && state.mounted) {
        _showOnState(state, message, isError: isError);
      }
    });
  }

  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state =
          ScaffoldMessenger.maybeOf(context) ??
          rootScaffoldMessengerKey.currentState;
      if (state != null && state.mounted) {
        _showOnState(state, message, isError: isError);
      }
    });
  }

  static void _showOnState(
    ScaffoldMessengerState state,
    String message, {
    required bool isError,
  }) {
    state.clearSnackBars();
    state.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? AppColors.error : AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.background,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isError ? AppColors.error : AppColors.primary,
            width: 1.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        duration: Duration(seconds: isError ? 4 : 2),
        elevation: 0,
      ),
    );
  }
}

typedef ErrorSnackbar = AppSnackbar;
