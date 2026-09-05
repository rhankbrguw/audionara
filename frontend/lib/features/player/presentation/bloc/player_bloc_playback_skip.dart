part of 'player_bloc.dart';

extension PlayerBlocPlaybackSkip on PlayerBloc {
  Future<void> _onNextRequested(PlayerNextRequested event, Emitter<PlayerState> emit) async {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    if (current.queue.isEmpty) return;

    _recordSkipOrCompleteMetrics(current);
    var nextIdx = current.currentIndex + 1;
    var queue = current.queue;
    var origQueue = current.originalQueue;

    if (nextIdx >= queue.length) {
      if (isRepeatEnabled) {
        nextIdx = 0;
      } else {
        final more = await _fetchSmartRadio(current);
        if (more.isNotEmpty) {
          queue = List<Track>.from(queue)..addAll(more);
          origQueue = List<Track>.from(origQueue)..addAll(more);
        } else {
          nextIdx = 0;
        }
      }
    } else if (nextIdx >= queue.length - 3 && !current.isLoadingMore) {
      add(const PlayerFetchMoreRequested());
    }

    final nextTrack = queue[nextIdx];
    emit(withMeta(
      current,
      track: nextTrack, queue: queue, originalQueue: origQueue,
      position: Duration.zero, duration: Duration(milliseconds: nextTrack.durationMs),
      currentIndex: nextIdx, isPlaying: true,
    ));

    await _playTrackSafely(nextTrack, emit);
    if (nextIdx + 1 < queue.length) _preWarmTrack(queue[nextIdx + 1]);
  }

  Future<void> _onPreviousRequested(PlayerPreviousRequested event, Emitter<PlayerState> emit) async {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    if (current.queue.isEmpty) return;

    if (current.position.inSeconds > 2) {
      await audioService.seek(Duration.zero);
      await audioService.resume();
      emit(withMeta(current, position: Duration.zero, isPlaying: true));
      return;
    }

    var prevIdx = current.currentIndex - 1;
    if (prevIdx < 0) {
      prevIdx = current.queue.length - 1;
    }

    final prevTrack = current.queue[prevIdx];
    emit(withMeta(
      current,
      track: prevTrack, position: Duration.zero,
      duration: Duration(milliseconds: prevTrack.durationMs),
      currentIndex: prevIdx, isPlaying: true,
    ));

    await _playTrackSafely(prevTrack, emit);
  }

  Future<void> _playTrackSafely(Track track, Emitter<PlayerState> emit) async {
    try {
      final streamUrl = await _buildStreamUrl(track);
      await audioService.play(streamUrl);
      unawaited(recentlyPlayedService.addTrack(track));
      unawaited(logHistoryUseCase(track));
    } catch (e) {
      if (track.streamUrl.isNotEmpty && track.streamUrl.startsWith('http')) {
        try {
          await audioService.play(track.streamUrl);
          return;
        } catch (_) {}
      }
      _handlePlaybackError(e, emit);
    }
  }

  void _recordSkipOrCompleteMetrics(PlayerPlaying current) {
    if (current.position.inSeconds < 10) {
      unawaited(recordMetricUseCase(current.track.id, current.currentVibe, 'skip'));
    } else if (current.duration.inSeconds > 0 && current.position.inSeconds > current.duration.inSeconds * 0.8) {
      unawaited(recordMetricUseCase(current.track.id, current.currentVibe, 'complete'));
    }
  }

  Future<List<Track>> _fetchSmartRadio(PlayerPlaying current) async {
    try {
      final query = current.track.artist.isNotEmpty ? current.track.artist : current.currentVibe;
      var smartTracks = await searchByVibeUseCase(query);
      if (smartTracks.isEmpty) smartTracks = await searchByVibeUseCase('trending');
      final filtered = smartTracks.where((t) => !current.queue.any(
        (q) => q.id == t.id || (q.title == t.title && q.artist == t.artist),
      )).toList();
      return isShuffleEnabled ? _fairShuffle(filtered) : filtered;
    } catch (_) {
      return [];
    }
  }

  void _handlePlaybackError(dynamic e, Emitter<PlayerState> emit) {
    final msg = (e is ServerException || e is NetworkException)
        ? (e as dynamic).message as String
        : 'Failed to play track. Please try again.';
    emit(PlayerError(message: msg));
  }
}


