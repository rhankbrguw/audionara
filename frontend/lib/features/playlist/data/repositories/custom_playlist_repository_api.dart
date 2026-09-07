part of 'custom_playlist_repository.dart';

extension CustomPlaylistRepositoryApi on CustomPlaylistRepository {
  Future<void> addTrack(
    String playlistId,
    CustomPlaylistTrackEntity track,
  ) async {
    return _execute(() async {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/v1/custom-playlists/$playlistId/tracks'),
            headers: _headers,
            body: jsonEncode({
              'trackId': track.trackId,
              'title': track.title,
              'artist': track.artist,
              'streamUrl': track.streamUrl,
              'coverArt': track.coverArt,
              'artistId': track.artistId,
              'albumId': track.albumId,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 201) {
        _handleError(response, 'Failed to add track');
      }
    });
  }

  Future<void> removeTrack(String playlistId, String trackId) async {
    return _execute(() async {
      final response = await _client
          .delete(
            Uri.parse(
              '$_baseUrl/api/v1/custom-playlists/$playlistId/tracks/$trackId',
            ),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        _handleError(response, 'Failed to remove track');
      }
    });
  }

  Future<List<CustomPlaylistTrackEntity>> getTracks(String playlistId) async {
    return _execute(() async {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/api/v1/custom-playlists/$playlistId/tracks'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _handleError(response, 'Failed to fetch tracks');
      }

      final trackList = jsonDecode(response.body)['data'] as List<dynamic>?;
      if (trackList == null) return [];

      return trackList.map((json) => _parseTrack(json)).toList();
    });
  }

  CustomPlaylistEntity _parsePlaylist(Map<String, dynamic> json) {
    String coverArtUrl = json['coverArtUrl'] ?? '';
    if (coverArtUrl.isNotEmpty && coverArtUrl.startsWith('/')) {
      coverArtUrl = '$_baseUrl$coverArtUrl';
    }
    return CustomPlaylistEntity()
      ..remoteId = json['id']
      ..userId = json['userId']
      ..name = json['name']
      ..bio = json['bio'] ?? ''
      ..coverArtUrl = coverArtUrl
      ..createdAt = DateTime.parse(json['createdAt']);
  }

  CustomPlaylistTrackEntity _parseTrack(Map<String, dynamic> json) {
    return CustomPlaylistTrackEntity()
      ..remoteId = json['id']
      ..playlistId = json['playlistId']
      ..trackId = json['trackId']
      ..title = json['title']
      ..artist = json['artist']
      ..streamUrl = json['streamUrl']
      ..coverArt = json['coverArt']
      ..artistId = json['artistId'] as String? ?? ''
      ..albumId = json['albumId'] as String? ?? ''
      ..addedAt = DateTime.parse(json['addedAt']);
  }
}
