import 'package:equatable/equatable.dart';
import '../../domain/entities/track.dart';

sealed class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

class PlayerInitial extends PlayerState {
  const PlayerInitial();
}

class PlayerLoading extends PlayerState {
  const PlayerLoading();
}

class PlayerPlaying extends PlayerState {
  const PlayerPlaying({
    required this.track,
    required this.position,
    required this.duration,
    required this.currentVibe,
    required this.queue,
    required this.originalQueue,
    required this.currentIndex,
    this.isPlaying = true,
    this.isShuffleEnabled = false,
    this.isRepeatEnabled = false,
    this.currentOffset = 0,
    this.isLoadingMore = false,
    this.sleepTimerRemaining,
  });

  final Track track;
  final Duration position;
  final Duration duration;
  final String currentVibe;
  final List<Track> queue;
  final List<Track> originalQueue;
  final int currentIndex;
  final bool isPlaying;
  final bool isShuffleEnabled;
  final bool isRepeatEnabled;
  final int currentOffset;
  final bool isLoadingMore;
  final int? sleepTimerRemaining;

  @override
  List<Object?> get props => [
    track,
    position,
    duration,
    currentVibe,
    queue,
    originalQueue,
    currentIndex,
    isPlaying,
    isShuffleEnabled,
    isRepeatEnabled,
    currentOffset,
    isLoadingMore,
    sleepTimerRemaining,
  ];
}

// Error state carries the message as a value — widgets project it into UI,
// no raw exception objects cross the BLoC boundary.
class PlayerError extends PlayerState {
  const PlayerError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
