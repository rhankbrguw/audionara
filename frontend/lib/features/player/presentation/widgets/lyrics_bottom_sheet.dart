import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/player_strings.dart';
import '../bloc/lyrics_bloc.dart';
import '../bloc/lyrics_event.dart';
import '../bloc/lyrics_state.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_state.dart';
import 'synced_lyrics_view.dart';

class LyricsBottomSheet extends StatefulWidget {
  final dynamic track;

  const LyricsBottomSheet({super.key, required this.track});

  @override
  State<LyricsBottomSheet> createState() => _LyricsBottomSheetState();
}

class _LyricsBottomSheetState extends State<LyricsBottomSheet> {
  String? _currentTrackId;

  @override
  void initState() {
    super.initState();
    _currentTrackId = widget.track?.id;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayerState>(
      listenWhen: (prev, curr) =>
          curr is PlayerPlaying && curr.track.id != _currentTrackId,
      listener: (context, state) {
        if (state is PlayerPlaying) {
          _currentTrackId = state.track.id;
          context.read<LyricsBloc>().add(
                FetchLyricsRequested(
                  artist: state.track.artist,
                  title: state.track.title,
                  durationMs: state.track.durationMs,
                ),
              );
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.6),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: BlocBuilder<LyricsBloc, LyricsState>(
                  builder: (context, lyricsState) => _buildContent(context, lyricsState),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LyricsState state) {
    if (state is LyricsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (state is LyricsError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    if (state is LyricsLoaded) {
      final synced = state.syncedLyrics;
      if (synced != null && synced.isNotEmpty) {
        return SyncedLyricsView(syncedLyrics: synced);
      }
      if (state.plainLyrics != null) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text(
              state.plainLyrics!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.8,
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
    return const Center(
      child: Text(
        PlayerStrings.noLyricsAvailable,
        style: TextStyle(color: AppColors.textSecondary),
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
