import 'package:equatable/equatable.dart';
import '../../domain/entities/custom_playlist_entity.dart';
import '../../domain/entities/custom_playlist_track_entity.dart';

sealed class CustomPlaylistEvent extends Equatable {
  const CustomPlaylistEvent();

  @override
  List<Object?> get props => [];
}

class FetchCustomPlaylistsRequested extends CustomPlaylistEvent {}

class CreateCustomPlaylistRequested extends CustomPlaylistEvent {
  const CreateCustomPlaylistRequested({
    required this.name,
    required this.bio,
    required this.coverArtFilePath,
  });
  final String name;
  final String bio;
  final String coverArtFilePath;

  @override
  List<Object?> get props => [name, bio, coverArtFilePath];
}

class DeleteCustomPlaylistRequested extends CustomPlaylistEvent {
  const DeleteCustomPlaylistRequested({required this.playlistId});
  final String playlistId;

  @override
  List<Object?> get props => [playlistId];
}

class UpdateCustomPlaylistRequested extends CustomPlaylistEvent {
  const UpdateCustomPlaylistRequested({
    required this.playlistId,
    required this.name,
    required this.bio,
    required this.coverArtFilePath,
    required this.existingCoverArtUrl,
  });

  final String playlistId;
  final String name;
  final String bio;
  final String coverArtFilePath;
  final String existingCoverArtUrl;

  @override
  List<Object?> get props => [
    playlistId,
    name,
    bio,
    coverArtFilePath,
    existingCoverArtUrl,
  ];
}

class FetchCustomPlaylistTracksRequested extends CustomPlaylistEvent {
  const FetchCustomPlaylistTracksRequested({required this.playlist});
  final CustomPlaylistEntity playlist;

  @override
  List<Object?> get props => [playlist];
}

class AddTrackToCustomPlaylistRequested extends CustomPlaylistEvent {
  const AddTrackToCustomPlaylistRequested({
    required this.playlistId,
    required this.track,
  });
  final String playlistId;
  final CustomPlaylistTrackEntity track;

  @override
  List<Object?> get props => [playlistId, track];
}

class RemoveTrackFromCustomPlaylistRequested extends CustomPlaylistEvent {
  const RemoveTrackFromCustomPlaylistRequested({
    required this.playlistId,
    required this.trackId,
  });
  final String playlistId;
  final String trackId;

  @override
  List<Object?> get props => [playlistId, trackId];
}
