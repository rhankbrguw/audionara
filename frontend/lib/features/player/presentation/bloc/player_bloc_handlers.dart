part of 'player_bloc.dart';

extension PlayerBlocHandlers on PlayerBloc {
  void onPaused(PlayerPaused event, Emitter<PlayerState> emit) =>
      audioService.pause();

  void onResumed(PlayerResumed event, Emitter<PlayerState> emit) =>
      audioService.resume();

  Future<void> onSeeked(PlayerSeeked event, Emitter<PlayerState> emit) async {
    _lastSeekTimeMs = DateTime.now().millisecondsSinceEpoch;
    if (state is PlayerPlaying) {
      emit(withMeta(state as PlayerPlaying, position: event.position));
    }
    await audioService.seek(event.position);
    if (state is PlayerPlaying && (state as PlayerPlaying).isPlaying) {
      await audioService.resume();
    }
  }

  void onDurationUpdated(
    PlayerDurationUpdated event,
    Emitter<PlayerState> emit,
  ) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    emit(withMeta(current, duration: event.duration));
  }

  void onPlayerStateChanged(
    PlayerStateChanged event,
    Emitter<PlayerState> emit,
  ) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;

    final isTerminal =
        event.state == ap.PlayerState.stopped ||
        (event.state == ap.PlayerState.completed && !isRepeatEnabled);

    if (event.state == ap.PlayerState.completed) {
      if (current.currentVibe != VibeType.playlist.key) {
        unawaited(
          recordMetricUseCase(
            current.track.id,
            current.currentVibe,
            'complete',
          ),
        );
      }

      if (isRepeatEnabled) {
        audioService.seek(Duration.zero);
        audioService.resume();
        emit(withMeta(current, position: Duration.zero, isPlaying: true));
      } else {
        add(const PlayerNextRequested());
      }
      return;
    }

    emit(
      withMeta(
        current,
        position: isTerminal ? Duration.zero : current.position,
        isPlaying:
            event.state == ap.PlayerState.playing ||
            (event.state == ap.PlayerState.completed && isRepeatEnabled),
      ),
    );
  }
}
