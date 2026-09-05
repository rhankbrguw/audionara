import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/player_strings.dart';
import '../bloc/lyrics_bloc.dart';
import '../bloc/lyrics_state.dart';
import 'synced_lyrics_view.dart';

class LyricsBottomSheet extends StatelessWidget {
  final dynamic track;

  const LyricsBottomSheet({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.6),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: BlocBuilder<LyricsBloc, LyricsState>(
                builder: (context, lyricsState) {
                  if (lyricsState is LyricsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (lyricsState is LyricsError) {
                    return Center(
                      child: Text(
                        lyricsState.message,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  } else if (lyricsState is LyricsLoaded) {
                    final syncedLyrics = lyricsState.syncedLyrics;
                    if (syncedLyrics != null && syncedLyrics.isNotEmpty) {
                      return SyncedLyricsView(syncedLyrics: syncedLyrics);
                    } else if (lyricsState.plainLyrics != null) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Text(
                            lyricsState.plainLyrics!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              height: 1.8,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          PlayerStrings.noLyricsAvailable,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLyricsBottomSheet(BuildContext context, dynamic track) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    constraints: const BoxConstraints(maxWidth: 600),
    useSafeArea: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.40,
        maxChildSize: 0.65,
        expand: false,
        builder: (_, controller) {
          return LyricsBottomSheet(track: track);
        },
      );
    },
  );
}
