import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/player_strings.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import '../../domain/entities/track.dart';
import 'queue_track_tile.dart';

class QueueBottomSheet extends StatelessWidget {
  const QueueBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Material(
        color: AppColors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: BlocBuilder<PlayerBloc, PlayerState>(
            builder: (context, state) {
              if (state is! PlayerPlaying) {
                return const Center(
                  child: Text(PlayerStrings.queueEmpty, style: TextStyle(color: AppColors.textSecondary)),
                );
              }
              return _buildContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PlayerPlaying state) {
    final upcoming = state.queue.sublist(
      (state.currentIndex + 1).clamp(0, state.queue.length),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDragHandle(),
        const SizedBox(height: 12),
        _buildHeader(upcoming.length),
        const SizedBox(height: 8),
        _buildNowPlaying(state),
        const Divider(color: AppColors.glassBorder, height: 24),
        Expanded(child: _buildUpcomingList(context, state, upcoming)),
      ],
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Row(
      children: [
        const Text(
          PlayerStrings.queueTitle,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text('$count ${PlayerStrings.queueNextUp}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildNowPlaying(PlayerPlaying state) {
    final current = state.queue[state.currentIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(PlayerStrings.nowPlaying, style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
        QueueTrackTile(
          track: current,
          index: state.currentIndex,
          isPlaying: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildUpcomingList(BuildContext context, PlayerPlaying state, List<Track> upcoming) {
    if (upcoming.isEmpty) {
      return const Center(
        child: Text(PlayerStrings.queueEmpty, style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ReorderableListView.builder(
      itemCount: upcoming.length,
      onReorderItem: (oldIdx, newIdx) {
        final actualOld = state.currentIndex + 1 + oldIdx;
        final actualNew = state.currentIndex + 1 + newIdx;
        context.read<PlayerBloc>().add(PlayerReorderQueue(oldIndex: actualOld, newIndex: actualNew));
      },
      itemBuilder: (context, index) {
        final track = upcoming[index];
        final actualIdx = state.currentIndex + 1 + index;
        return QueueTrackTile(
          key: ValueKey('${track.id}_$actualIdx'),
          track: track,
          index: index,
          isPlaying: false,
          onTap: () => context.read<PlayerBloc>().add(PlayTrackEvent(track, state.queue)),
          onRemove: () => context.read<PlayerBloc>().add(PlayerRemoveFromQueue(actualIdx)),
        );
      },
    );
  }
}

void showQueueBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    constraints: const BoxConstraints(maxWidth: 600),
    useSafeArea: true,
    builder: (_) => const FractionallySizedBox(heightFactor: 0.75, child: QueueBottomSheet()),
  );
}
