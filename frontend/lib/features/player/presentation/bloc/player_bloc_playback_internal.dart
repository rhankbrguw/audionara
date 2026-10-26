part of 'player_bloc.dart';

extension PlayerBlocPlaybackInternal on PlayerBloc {
  Future<void> _onPlayTrackEvent(
    PlayTrackEvent event,
    Emitter<PlayerState> emit,
  ) async {
    emit(const PlayerLoading());
    try {
      final track = event.track as Track;
      final queue = List<Track>.from(event.queue);
      var currentIndex = queue.indexOf(track);
      if (currentIndex == -1) {
        queue.insert(0, track);
        currentIndex = 0;
      }

      final currentVibe = VibeType.playlist.key;

      emit(
        PlayerPlaying(
          track: track,
          position: Duration.zero,
          duration: Duration(milliseconds: track.durationMs),
          currentVibe: currentVibe,
          queue: queue,
          originalQueue: List<Track>.from(queue),
          currentIndex: currentIndex,
          isShuffleEnabled: isShuffleEnabled,
          isRepeatEnabled: isRepeatEnabled,
        ),
      );

      final streamUrl = await _buildStreamUrl(track);
      await audioService.play(streamUrl);
      unawaited(recentlyPlayedService.addTrack(track));
      unawaited(logHistoryUseCase(track));
      if (currentIndex + 1 < queue.length) {
        _preWarmTrack(queue[currentIndex + 1]);
      }

      if (queue.length == 1) {
        unawaited(() async {
          try {
            final smartQueue = await searchByVibeUseCase(track.artist);
            if (smartQueue.isNotEmpty) {
              final newQueue = List<Track>.from(queue);
              for (var st in smartQueue) {
                if (st.id != track.id) {
                  newQueue.add(st);
                }
              }
              add(PlayerQueueUpdated(newQueue));
            }
          } catch (_) {}
        }());
      }
    } catch (e) {
      if (e is ServerException) {
        emit(PlayerError(message: e.message));
      } else if (e is NetworkException) {
        emit(PlayerError(message: e.message));
      } else {
        emit(const PlayerError(message: 'Failed to play track. Please try again.'));
      }
    }
  }
}
