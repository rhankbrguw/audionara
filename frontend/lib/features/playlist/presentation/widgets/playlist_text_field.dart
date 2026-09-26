import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PlaylistTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const PlaylistTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
