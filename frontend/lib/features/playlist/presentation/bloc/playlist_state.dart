import 'package:equatable/equatable.dart';
import '../../domain/entities/playlist_item.dart';

sealed class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object?> get props => [];
}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  const PlaylistLoaded({required this.favourites});

  final List<PlaylistItem> favourites;

  @override
  List<Object?> get props => [favourites];
}

class PlaylistTrackStatus extends PlaylistState {
  const PlaylistTrackStatus({required this.trackId, required this.isSaved});

  final String trackId;
  final bool isSaved;

  @override
  List<Object?> get props => [trackId, isSaved];
}

/// Emitted after a successful toggle so the UI can show a snackbar.
class FavouriteToggled extends PlaylistState {
  const FavouriteToggled({required this.trackId, required this.isSaved});

  final String trackId;
  final bool isSaved;

  @override
  List<Object?> get props => [trackId, isSaved];
}

class PlaylistError extends PlaylistState {
  const PlaylistError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
