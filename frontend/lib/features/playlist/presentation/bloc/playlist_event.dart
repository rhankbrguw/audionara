import 'package:equatable/equatable.dart';
import '../../domain/entities/playlist_item.dart';

sealed class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavourites extends PlaylistEvent {}

class ToggleFavouriteStatus extends PlaylistEvent {
  const ToggleFavouriteStatus({required this.item});

  final PlaylistItem item;

  @override
  List<Object?> get props => [item];
}

class CheckFavouriteStatus extends PlaylistEvent {
  const CheckFavouriteStatus({required this.trackId});

  final String trackId;

  @override
  List<Object?> get props => [trackId];
}
