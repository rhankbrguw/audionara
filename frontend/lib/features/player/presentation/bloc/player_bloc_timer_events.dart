part of 'player_bloc.dart';

extension PlayerBlocTimerEvents on PlayerBloc {
  void onSleepTimerSet(PlayerSleepTimerSet event, Emitter<PlayerState> emit) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;

    _sleepTimer?.cancel();
    _sleepTimerRemaining = event.minutes * 60;

    emit(withMeta(current, sleepTimerRemaining: event.minutes));

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sleepTimerRemaining! <= 0) {
        timer.cancel();
        _sleepTimerRemaining = null;
        add(const PlayerPaused());
        add(const PlayerSleepTimerCancelled());
      } else {
        _sleepTimerRemaining = _sleepTimerRemaining! - 1;
        if (_sleepTimerRemaining! % 60 == 0) {
          final mins = _sleepTimerRemaining! ~/ 60;
          add(PlayerSleepTimerTicked(mins));
        }
      }
    });
  }

  void onSleepTimerTicked(
    PlayerSleepTimerTicked event,
    Emitter<PlayerState> emit,
  ) {
    if (state is! PlayerPlaying) return;
    emit(withMeta(state as PlayerPlaying, sleepTimerRemaining: event.minutesRemaining));
  }

  void onSleepTimerCancelled(
    PlayerSleepTimerCancelled event,
    Emitter<PlayerState> emit,
  ) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;

    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerRemaining = null;

    emit(withMeta(current, clearSleepTimer: true));
  }
}
