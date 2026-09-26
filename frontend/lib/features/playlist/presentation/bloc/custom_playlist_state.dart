import 'package:equatable/equatable.dart';
import '../../domain/entities/custom_playlist_entity.dart';
import '../../domain/entities/custom_playlist_track_entity.dart';

sealed class CustomPlaylistState extends Equatable {
  const CustomPlaylistState();

  @override
  List<Object?> get props => [];
}

class CustomPlaylistInitial extends CustomPlaylistState {}

class CustomPlaylistLoading extends CustomPlaylistState {}

class CustomPlaylistsLoaded extends CustomPlaylistState {
  const CustomPlaylistsLoaded({required this.playlists});

  final List<CustomPlaylistEntity> playlists;

  @override
  List<Object?> get props => [playlists];
}

class CustomPlaylistTracksLoaded extends CustomPlaylistsLoaded {
  const CustomPlaylistTracksLoaded({
    required super.playlists,
    required this.playlist,
    required this.tracks,
  });

  final CustomPlaylistEntity playlist;
  final List<CustomPlaylistTrackEntity> tracks;

  @override
  List<Object?> get props => [playlists, playlist, tracks];
}

class CustomPlaylistError extends CustomPlaylistState {
  const CustomPlaylistError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class CustomPlaylistUpdated extends CustomPlaylistState {
  const CustomPlaylistUpdated({required this.playlist});
  final CustomPlaylistEntity playlist;

  @override
  List<Object?> get props => [playlist];
}
