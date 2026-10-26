import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/constants/app_strings.dart';

class PlaylistCoverArtPicker extends StatelessWidget {
  const PlaylistCoverArtPicker({
    super.key,
    required this.onTap,
    required this.coverArtPath,
    this.existingCoverArtUrl = '',
  });

  final VoidCallback onTap;
  final String coverArtPath;
  final String existingCoverArtUrl;

  @override
  Widget build(BuildContext context) {
    final hasNewImage = coverArtPath.isNotEmpty;
    final hasExistingImage = existingCoverArtUrl.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          image: hasNewImage
              ? DecorationImage(
                  image: FileImage(File(coverArtPath)),
                  fit: BoxFit.cover,
                )
              : hasExistingImage
              ? DecorationImage(
                  image: NetworkImage(existingCoverArtUrl),
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: (!hasNewImage && !hasExistingImage)
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: AppColors.primary, size: 36),
                  SizedBox(height: 8),
                  Text(
                    PlaylistStrings.addCoverArt,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            : const Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: AppColors.surface,
                    radius: 16,
                    child: Icon(
                      Icons.edit,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
