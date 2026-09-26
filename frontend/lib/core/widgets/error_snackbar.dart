import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'sonner_toast.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppSnackbar {
  static OverlayEntry? _currentEntry;

  static void showError(BuildContext context, String message) {
    show(context, message, isError: true);
  }

  static void showGlobal(String message, {bool isError = false}) {
    final state = rootScaffoldMessengerKey.currentState;
    if (state != null && state.mounted) {
      _showFallbackSnackBar(state, message, isError: isError);
    }
  }

  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.maybeOf(context, rootOverlay: true);
      if (overlay != null && overlay.mounted) {
        _showOverlayToast(overlay, message, isError: isError);
        return;
      }
      final state =
          ScaffoldMessenger.maybeOf(context) ??
          rootScaffoldMessengerKey.currentState;
      if (state != null && state.mounted) {
        _showFallbackSnackBar(state, message, isError: isError);
      }
    });
  }

  static void _showOverlayToast(
    OverlayState overlay,
    String message, {
    required bool isError,
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => SonnerToast(
        message: message,
        isError: isError,
        onDismiss: () {
          if (_currentEntry == entry) {
            entry.remove();
            _currentEntry = null;
          }
        },
      ),
    );
    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void _showFallbackSnackBar(
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
        backgroundColor: AppColors.surfaceVariant,
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
      ),
    );
  }
}

typedef ErrorSnackbar = AppSnackbar;

