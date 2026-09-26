import 'package:equatable/equatable.dart';

abstract class LyricsState extends Equatable {
  const LyricsState();

  @override
  List<Object?> get props => [];
}

class LyricsInitial extends LyricsState {}

class LyricsLoading extends LyricsState {}

class LyricLine {
  final Duration time;
  final String text;

  const LyricLine({required this.time, required this.text});
}

class LyricsLoaded extends LyricsState {
  final String? plainLyrics;
  final List<LyricLine>? syncedLyrics;

  const LyricsLoaded({this.plainLyrics, this.syncedLyrics});

  @override
  List<Object?> get props => [plainLyrics, syncedLyrics];
}

class LyricsError extends LyricsState {
  final String message;

  const LyricsError({required this.message});

  @override
  List<Object?> get props => [message];
}
