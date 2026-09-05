import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/settings_strings.dart';
import '../../../../features/user/presentation/bloc/user_bloc.dart';
import '../../../../features/user/presentation/bloc/user_state.dart';
import '../pages/edit_profile_page.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is UserLoaded) {
          final user = state.user;
          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.surface,
                backgroundImage: user.profilePictureUrl.isNotEmpty
                    ? NetworkImage(
                        '${AppConstants.apiBaseUrl}${user.profilePictureUrl}',
                      )
                    : null,
                child: user.profilePictureUrl.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.username,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.bio.isNotEmpty ? user.bio : SettingsStrings.bioHint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  SettingsStrings.editProfile,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        } else if (state is UserError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
