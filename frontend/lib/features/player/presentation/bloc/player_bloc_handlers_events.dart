part of 'player_bloc.dart';

extension PlayerBlocHandlersEvents on PlayerBloc {
  void onPositionUpdated(
    PlayerPositionUpdated event,
    Emitter<PlayerState> emit,
  ) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;

    if (DateTime.now().millisecondsSinceEpoch - _lastSeekTimeMs < 400) {
      return;
    }

    if (current.duration.inMilliseconds == 0 &&
        event.position.inMilliseconds > 200) {
      audioService.getDuration().then((d) {
        if (d != null && d.inMilliseconds > 0) {
          add(PlayerDurationUpdated(duration: d));
        }
      });
    }

    emit(withMeta(current, position: event.position));
  }

  Future<void> onFetchMoreRequested(
    PlayerFetchMoreRequested event,
    Emitter<PlayerState> emit,
  ) async {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;

    if (current.isLoadingMore || current.currentVibe == VibeType.playlist.key) {
      return;
    }
    emit(withMeta(current, isLoadingMore: true));

    try {
      final nextOffset = current.currentOffset + current.queue.length;
      final newTracks = List<Track>.from(
        await searchByVibeUseCase(current.currentVibe, offset: nextOffset),
      );

      if (newTracks.isEmpty) {
        emit(withMeta(current, isLoadingMore: false));
        return;
      }

      if (isShuffleEnabled) newTracks.shuffle();

      final updatedQueue = List<Track>.from(current.queue)..addAll(newTracks);
      final updatedOriginalQueue = List<Track>.from(current.originalQueue)
        ..addAll(newTracks);

      emit(
        withMeta(
          current,
          queue: updatedQueue,
          originalQueue: updatedOriginalQueue,
          currentOffset: nextOffset,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      if (e is ServerException) {
        emit(PlayerError(message: e.message));
      } else if (e is NetworkException) {
        emit(PlayerError(message: e.message));
      } else {
        emit(const PlayerError(message: 'Failed to fetch more tracks. Please try again.'));
      }
    }
  }

  PlayerPlaying withMeta(
    PlayerPlaying current, {
    Track? track,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    List<Track>? queue,
    List<Track>? originalQueue,
    int? currentIndex,
    int? currentOffset,
    bool? isLoadingMore,
    int? sleepTimerRemaining,
    bool clearSleepTimer = false,
  }) => PlayerPlaying(
    track: track ?? current.track,
    position: position ?? current.position,
    duration: duration ?? current.duration,
    currentVibe: current.currentVibe,
    queue: queue ?? current.queue,
    originalQueue: originalQueue ?? current.originalQueue,
    currentIndex: currentIndex ?? current.currentIndex,
    isPlaying: isPlaying ?? current.isPlaying,
    isShuffleEnabled: isShuffleEnabled,
    isRepeatEnabled: isRepeatEnabled,
    currentOffset: currentOffset ?? current.currentOffset,
    isLoadingMore: isLoadingMore ?? current.isLoadingMore,
    sleepTimerRemaining: clearSleepTimer
        ? null
        : (sleepTimerRemaining ?? current.sleepTimerRemaining),
  );
}
