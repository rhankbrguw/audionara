part of 'player_bloc.dart';

extension PlayerBlocPlayback on PlayerBloc {
  Future<String> _buildStreamUrl(Track track) async {
    final prefs = await SharedPreferences.getInstance();
    final hideExplicit = prefs.getBool('hide_explicit') ?? false;
    final quality = prefs.getInt('audio_quality') ?? 128;

    var url = track.streamUrl;
    bool isInternal = false;

    if (url.isEmpty || !url.startsWith('http')) {
      final encodedArtist = Uri.encodeComponent(track.artist);
      final encodedTitle = Uri.encodeComponent(track.title);
      url = '${AppConstants.apiBaseUrl}/api/v1/tracks/stream.m4a?artist=$encodedArtist&title=$encodedTitle';
      isInternal = true;
    } else if (url.contains('audio-ssl.itunes.apple.com')) {
      final encodedArtist = Uri.encodeComponent(track.artist);
      final encodedTitle = Uri.encodeComponent(track.title);
      url = '${AppConstants.apiBaseUrl}/api/v1/tracks/stream.m4a?artist=$encodedArtist&title=$encodedTitle';
      isInternal = true;
    } else if (url.startsWith('http://localhost:8080')) {
      url = url.replaceFirst('http://localhost:8080', AppConstants.apiBaseUrl);
      isInternal = true;
    } else if (url.startsWith('http://127.0.0.1:8080')) {
      url = url.replaceFirst('http://127.0.0.1:8080', AppConstants.apiBaseUrl);
      isInternal = true;
    } else if (url.startsWith(AppConstants.apiBaseUrl)) {
      isInternal = true;
    }

    if (isInternal) {
      final sep = url.contains('?') ? '&' : '?';
      return '$url${sep}explicit=${!hideExplicit}&quality=$quality';
    }

    return url;
  }


  Future<void> _onVibeRequested(
    PlayerVibeRequested event,
    Emitter<PlayerState> emit,
  ) async {
    emit(const PlayerLoading());
    try {
      final tracks = List<Track>.from(
        await searchByVibeUseCase(event.vibe),
      );
      if (isShuffleEnabled) tracks.shuffle();

      if (tracks.isEmpty) {
        emit(const PlayerError(message: 'No tracks found for this vibe.'));
        return;
      }

      emit(
        PlayerPlaying(
          track: tracks.first,
          position: Duration.zero,
          duration: Duration(milliseconds: tracks.first.durationMs),
          currentVibe: event.vibe,
          queue: tracks,
          originalQueue: List<Track>.from(tracks),
          currentIndex: 0,
          isShuffleEnabled: isShuffleEnabled,
          isRepeatEnabled: isRepeatEnabled,
        ),
      );

      final streamUrl = await _buildStreamUrl(tracks.first);
      await audioService.play(streamUrl);
      unawaited(recentlyPlayedService.addTrack(tracks.first));
      unawaited(logHistoryUseCase(tracks.first));
      if (tracks.length > 1) _preWarmTrack(tracks[1]);
    } catch (e) {
      if (e is ServerException) {
        emit(PlayerError(message: e.message));
      } else if (e is NetworkException) {
        emit(PlayerError(message: e.message));
      } else {
        emit(const PlayerError(message: 'Failed to play track. Please try again.'));
      }
    }
  }

  Future<void> _onMixForYouRequested(
    PlayerMixForYouRequested event,
    Emitter<PlayerState> emit,
  ) async {
    emit(const PlayerLoading());
    try {
      final tracks = List<Track>.from(await fetchMixForYouUseCase());
      if (isShuffleEnabled) tracks.shuffle();

      if (tracks.isEmpty) {
        emit(
          const PlayerError(message: 'No tracks available for Mix For You.'),
        );
        return;
      }

      emit(
        PlayerPlaying(
          track: tracks.first,
          position: Duration.zero,
          duration: Duration(milliseconds: tracks.first.durationMs),
          currentVibe: VibeType.mixForYou.key,
          queue: tracks,
          originalQueue: List<Track>.from(tracks),
          currentIndex: 0,
          isShuffleEnabled: isShuffleEnabled,
          isRepeatEnabled: isRepeatEnabled,
        ),
      );

      final streamUrl = await _buildStreamUrl(tracks.first);
      await audioService.play(streamUrl);
      unawaited(recentlyPlayedService.addTrack(tracks.first));
      unawaited(logHistoryUseCase(tracks.first));
      if (tracks.length > 1) _preWarmTrack(tracks[1]);
    } catch (e) {
      if (e is ServerException) {
        emit(PlayerError(message: e.message));
      } else if (e is NetworkException) {
        emit(PlayerError(message: e.message));
      } else {
        emit(const PlayerError(message: 'Failed to play track. Please try again.'));
      }
    }
  }

  void _preWarmTrack(Track? track) {
    if (track == null) return;
    unawaited(() async {
      try {
        final url = await _buildStreamUrl(track);
        if (url.startsWith(AppConstants.apiBaseUrl)) {
          final client = http.Client();
          await client.head(Uri.parse(url)).timeout(const Duration(seconds: 4));
          client.close();
        }
      } catch (_) {}
    }());
  }
}
