part of 'custom_playlist_bloc.dart';

extension CustomPlaylistBlocHandlersWrite on CustomPlaylistBloc {
  Future<void> onCreatePlaylist(
    CreateCustomPlaylistRequested event,
    Emitter<CustomPlaylistState> emit,
  ) async {
    emit(CustomPlaylistLoading());
    try {
      String coverArtUrl = '';
      if (event.coverArtFilePath.isNotEmpty) {
        coverArtUrl = await repository.uploadCoverArt(event.coverArtFilePath);
      }

      await repository.createPlaylist(event.name, event.bio, coverArtUrl);
      add(FetchCustomPlaylistsRequested());
    } catch (e) {
      emitError(e, emit);
    }
  }

  Future<void> onUpdatePlaylist(
    UpdateCustomPlaylistRequested event,
    Emitter<CustomPlaylistState> emit,
  ) async {
    CustomPlaylistTracksLoaded? tracksState;
    if (state is CustomPlaylistTracksLoaded) {
      tracksState = state as CustomPlaylistTracksLoaded;
    }
    emit(CustomPlaylistLoading());
    try {
      String coverArtUrl = event.existingCoverArtUrl;
      if (event.coverArtFilePath.isNotEmpty) {
        coverArtUrl = await repository.uploadCoverArt(event.coverArtFilePath);
      }
      final updated = await repository.updatePlaylist(
        event.playlistId,
        event.name,
        event.bio,
        coverArtUrl,
      );
      emit(CustomPlaylistUpdated(playlist: updated));
      if (tracksState != null) {
        final updatedPlaylists = tracksState.playlists
            .map((p) => p.remoteId == updated.remoteId ? updated : p)
            .toList();
        emit(
          CustomPlaylistTracksLoaded(
            playlists: updatedPlaylists,
            playlist: updated,
            tracks: tracksState.tracks,
          ),
        );
      }
      add(FetchCustomPlaylistsRequested());
    } catch (e) {
      emitError(e, emit);
    }
  }

  Future<void> onDeletePlaylist(
    DeleteCustomPlaylistRequested event,
    Emitter<CustomPlaylistState> emit,
  ) async {
    emit(CustomPlaylistLoading());
    try {
      await repository.deletePlaylist(event.playlistId);
      add(FetchCustomPlaylistsRequested());
    } catch (e) {
      emitError(e, emit);
    }
  }

  Future<void> onAddTrack(
    AddTrackToCustomPlaylistRequested event,
    Emitter<CustomPlaylistState> emit,
  ) async {
    CustomPlaylistTracksLoaded? rollbackState;
    if (state is CustomPlaylistTracksLoaded) {
      final current = state as CustomPlaylistTracksLoaded;
      if (current.playlist.remoteId == event.playlistId) {
        rollbackState = current;
        final updatedTracks = List<CustomPlaylistTrackEntity>.from(
          current.tracks,
        )..add(event.track);
        emit(
          CustomPlaylistTracksLoaded(
            playlists: current.playlists,
            playlist: current.playlist,
            tracks: updatedTracks,
          ),
        );
      }
    }

    try {
      await repository.addTrack(event.playlistId, event.track);
    } catch (e) {
      if (rollbackState != null) emit(rollbackState);
      emitError(e, emit);
    }
  }

  Future<void> onRemoveTrack(
    RemoveTrackFromCustomPlaylistRequested event,
    Emitter<CustomPlaylistState> emit,
  ) async {
    CustomPlaylistTracksLoaded? rollbackState;
    if (state is CustomPlaylistTracksLoaded) {
      final current = state as CustomPlaylistTracksLoaded;
      if (current.playlist.remoteId == event.playlistId) {
        rollbackState = current;
        final updatedTracks = current.tracks
            .where((t) => t.trackId != event.trackId)
            .toList();
        emit(
          CustomPlaylistTracksLoaded(
            playlists: current.playlists,
            playlist: current.playlist,
            tracks: updatedTracks,
          ),
        );
      }
    }

    try {
      await repository.removeTrack(event.playlistId, event.trackId);
    } catch (e) {
      if (rollbackState != null) emit(rollbackState);
      emitError(e, emit);
    }
  }
}
