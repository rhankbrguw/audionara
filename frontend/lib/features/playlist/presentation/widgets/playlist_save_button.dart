import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/custom_playlist_bloc.dart';
import '../bloc/custom_playlist_state.dart';

class PlaylistSaveButton extends StatelessWidget {
  final VoidCallback onSave;
  final String text;

  const PlaylistSaveButton({
    super.key,
    required this.onSave,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: BlocBuilder<CustomPlaylistBloc, CustomPlaylistState>(
        builder: (context, state) {
          final isLoading = state is CustomPlaylistLoading;
          return ElevatedButton(
            onPressed: isLoading ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: AppColors.textInverse)
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textInverse,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
