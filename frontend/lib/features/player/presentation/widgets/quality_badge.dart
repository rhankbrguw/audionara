import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/player_strings.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../settings/presentation/bloc/settings_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class QualityBadge extends StatelessWidget {
  const QualityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const SizedBox.shrink(); // Hide lossless feature for unregistered
        }
        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            if (settingsState.streamQualityKbps != 256) {
              return const SizedBox.shrink();
            }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.glassOverlay,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.graphic_eq_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  PlayerStrings.hiResLossless,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
          ),
        );
          },
        );
      },
    );
  }
}
