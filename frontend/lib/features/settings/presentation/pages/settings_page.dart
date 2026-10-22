import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';
import '../widgets/profile_section.dart';
import '../widgets/guest_section.dart';
import '../widgets/playback_settings_section.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            SettingsStrings.settings,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ResponsiveWrapper(
          maxWidth: 800,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final isAuthenticated = authState is AuthAuthenticated;
                  return ListView(
                    padding: const EdgeInsets.all(24.0),
                  children: [
                    if (isAuthenticated)
                      const ProfileSection()
                    else
                      const GuestSection(),

                    PlaybackSettingsSection(
                      streamQualityKbps: settingsState.streamQualityKbps,
                      filterExplicit: settingsState.filterExplicit,
                    ),

                    const SizedBox(height: 48),
                    if (isAuthenticated)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AuthBloc>().add(LogoutRequested());
                        },
                        icon: const Icon(Icons.logout_rounded, size: 20),
                        label: const Text(
                          SettingsStrings.logout,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go('/login');
                        },
                        icon: const Icon(Icons.login_rounded, size: 20),
                        label: const Text(
                          AuthStrings.login,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textInverse,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    ),
  );
  }
}
