import 'package:equatable/equatable.dart';

abstract class LyricsEvent extends Equatable {
  const LyricsEvent();

  @override
  List<Object?> get props => [];
}

class FetchLyricsRequested extends LyricsEvent {
  final String artist;
  final String title;
  final int durationMs;

  const FetchLyricsRequested({
    required this.artist,
    required this.title,
    this.durationMs = 0,
  });

  @override
  List<Object?> get props => [artist, title, durationMs];
}
