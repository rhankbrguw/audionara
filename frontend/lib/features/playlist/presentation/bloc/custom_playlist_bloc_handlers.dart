part of 'custom_playlist_bloc.dart';

extension CustomPlaylistBlocHandlers on CustomPlaylistBloc {
  Future<void> onFetchPlaylists(
    FetchCustomPlaylistsRequested event,
    Emitter<CustomPlaylistState> emit,
  ) async {
    CustomPlaylistTracksLoaded? tracksState;
    if (state is CustomPlaylistTracksLoaded) {
      tracksState = state as CustomPlaylistTracksLoaded;
    }
    emit(CustomPlaylistLoading());
    try {
      final playlists = await repository.getPlaylists();
      if (tracksState != null) {
        final currentPlaylist = playlists.firstWhere(
          (p) => p.remoteId == tracksState!.playlist.remoteId,
          orElse: () => tracksState!.playlist,
        );
        emit(
          CustomPlaylistTracksLoaded(
            playlists: playlists,
            playlist: currentPlaylist,
            tracks: tracksState.tracks,
          ),
        );
      } else {
        emit(CustomPlaylistsLoaded(playlists: playlists));
      }
    } catch (e) {
      emitError(e, emit);
    }
  }



  Future<void> onFetchPlaylistTracks(
    FetchCustomPlaylistTracksRequested event,
    Emitter<CustomPlaylistState> emit,
  ) async {
    List<CustomPlaylistEntity> currentPlaylists = [];
    if (state is CustomPlaylistsLoaded) {
      currentPlaylists = (state as CustomPlaylistsLoaded).playlists;
    }
    emit(CustomPlaylistLoading());
    try {
      final tracks = await repository.getTracks(event.playlist.remoteId);
      emit(
        CustomPlaylistTracksLoaded(
          playlists: currentPlaylists,
          playlist: event.playlist,
          tracks: tracks,
        ),
      );
    } catch (e) {
      emitError(e, emit);
    }
  }


}
