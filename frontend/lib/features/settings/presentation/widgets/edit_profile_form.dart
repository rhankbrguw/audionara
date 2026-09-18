import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/settings_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'edit_profile_avatar.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final String selectedImagePath;
  final String? profilePictureUrl;
  final VoidCallback onPickImage;
  final VoidCallback onSave;
  final VoidCallback onChangePassword;
  final bool isLoading;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.bioController,
    required this.selectedImagePath,
    this.profilePictureUrl,
    required this.onPickImage,
    required this.onSave,
    required this.onChangePassword,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditProfileAvatar(
            selectedImagePath: selectedImagePath,
            profilePictureUrl: profilePictureUrl,
            onPickImage: onPickImage,
          ),
          const SizedBox(height: 24),
          _buildFieldLabel(context, SettingsStrings.usernameLabel),
          const SizedBox(height: 8),
          CustomTextField(
            controller: usernameController,
            hint: SettingsStrings.usernameHint,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(context, SettingsStrings.emailLabel),
          const SizedBox(height: 8),
          CustomTextField(
            controller: emailController,
            hint: SettingsStrings.emailHint,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildFieldLabel(context, SettingsStrings.bioLabel),
          const SizedBox(height: 8),
          _buildBioField(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onChangePassword,
              icon: const Icon(Icons.lock_reset, color: AppColors.primary, size: 18),
              label: const Text(
                SettingsStrings.changePassword,
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBioField() {
    return TextFormField(
      controller: bioController,
      style: const TextStyle(color: AppColors.textPrimary),
      maxLines: 3,
      maxLength: 150,
      decoration: InputDecoration(
        hintText: SettingsStrings.bioHint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.onPrimary, strokeWidth: 2))
          : const Text(SettingsStrings.saveChanges, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}
