import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayerVibeRequested extends PlayerEvent {
  const PlayerVibeRequested({required this.vibe});

  final String vibe;

  @override
  List<Object?> get props => [vibe];
}

class PlayTrackEvent extends PlayerEvent {
  const PlayTrackEvent(this.track, this.queue);

  final dynamic
  track; // Using dynamic because it can be Track, or it could be imported
  final List<dynamic> queue;

  @override
  List<Object?> get props => [track, queue];
}

class PlayerMixForYouRequested extends PlayerEvent {
  const PlayerMixForYouRequested();
}

class PlayerPaused extends PlayerEvent {
  const PlayerPaused();
}

class PlayerResumed extends PlayerEvent {
  const PlayerResumed();
}

class PlayerSeeked extends PlayerEvent {
  const PlayerSeeked({required this.position});

  final Duration position;

  @override
  List<Object?> get props => [position];
}

// Internal event — emitted by the audio engine, never by the UI layer.
// Keeps position ticks inside the BLoC to decouple the audio engine lifecycle.
class PlayerPositionUpdated extends PlayerEvent {
  const PlayerPositionUpdated({required this.position});

  final Duration position;

  @override
  List<Object?> get props => [position];
}

class PlayerDurationUpdated extends PlayerEvent {
  const PlayerDurationUpdated({required this.duration});

  final Duration duration;

  @override
  List<Object?> get props => [duration];
}

class PlayerStateChanged extends PlayerEvent {
  const PlayerStateChanged({required this.state});

  final dynamic state; // audioplayers PlayerState

  @override
  List<Object?> get props => [state];
}

class PlayerToggleShuffle extends PlayerEvent {
  const PlayerToggleShuffle();
}

class PlayerToggleRepeat extends PlayerEvent {
  const PlayerToggleRepeat();
}

class PlayerNextRequested extends PlayerEvent {
  const PlayerNextRequested();
}

class PlayerPreviousRequested extends PlayerEvent {
  const PlayerPreviousRequested();
}

class PlayerFetchMoreRequested extends PlayerEvent {
  const PlayerFetchMoreRequested();
}

class PlayerSleepTimerSet extends PlayerEvent {
  const PlayerSleepTimerSet(this.minutes);
  final int minutes;

  @override
  List<Object?> get props => [minutes];
}

class PlayerSleepTimerCancelled extends PlayerEvent {
  const PlayerSleepTimerCancelled();
}

class PlayerSleepTimerTicked extends PlayerEvent {
  const PlayerSleepTimerTicked(this.minutesRemaining);
  final int minutesRemaining;

  @override
  List<Object?> get props => [minutesRemaining];
}

class PlayerQueueUpdated extends PlayerEvent {
  const PlayerQueueUpdated(this.queue);
  final List<dynamic> queue;

  @override
  List<Object?> get props => [queue];
}
