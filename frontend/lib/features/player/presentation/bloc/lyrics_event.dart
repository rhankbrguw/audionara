import 'package:equatable/equatable.dart';

abstract class LyricsEvent extends Equatable {
  const LyricsEvent();

  @override
  List<Object?> get props => [];
}

class FetchLyricsRequested extends LyricsEvent {
  final String artist;
  final String title;

  const FetchLyricsRequested({required this.artist, required this.title});

  @override
  List<Object?> get props => [artist, title];
}
