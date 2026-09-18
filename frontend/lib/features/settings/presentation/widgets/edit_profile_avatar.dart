import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class EditProfileAvatar extends StatelessWidget {
  final String selectedImagePath;
  final String? profilePictureUrl;
  final VoidCallback onPickImage;

  const EditProfileAvatar({
    super.key,
    required this.selectedImagePath,
    this.profilePictureUrl,
    required this.onPickImage,
  });

  ImageProvider? _getAvatarImage() {
    if (selectedImagePath.isNotEmpty) {
      return FileImage(File(selectedImagePath));
    }
    if (profilePictureUrl != null && profilePictureUrl!.isNotEmpty) {
      return NetworkImage(
        '${AppConstants.apiBaseUrl}$profilePictureUrl',
      );
    }
    return null;
  }

  bool _shouldShowPersonIcon() {
    return selectedImagePath.isEmpty && (profilePictureUrl == null || profilePictureUrl!.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.surface,
            backgroundImage: _getAvatarImage(),
            child: _shouldShowPersonIcon()
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.textSecondary,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
