part of 'custom_playlist_repository.dart';

extension CustomPlaylistRepositoryCrud on CustomPlaylistRepository {
  Future<CustomPlaylistEntity> createPlaylist(
    String name,
    String bio,
    String coverArtUrl,
  ) async {
    return _execute(() async {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/v1/custom-playlists'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'bio': bio,
              'coverArtUrl': coverArtUrl,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 201) {
        _handleError(response, 'Failed to create playlist');
      }

      final json = jsonDecode(response.body)['data'];
      return _parsePlaylist(json);
    });
  }

  Future<List<CustomPlaylistEntity>> getPlaylists() async {
    return _execute(() async {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/api/v1/custom-playlists'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _handleError(response, 'Failed to fetch playlists');
      }

      final playlistList = jsonDecode(response.body)['data'] as List<dynamic>?;
      if (playlistList == null) return [];

      return playlistList.map((json) => _parsePlaylist(json)).toList();
    });
  }

  Future<CustomPlaylistEntity> updatePlaylist(
    String id,
    String name,
    String bio,
    String coverArtUrl,
  ) async {
    return _execute(() async {
      final response = await _client
          .put(
            Uri.parse('$_baseUrl/api/v1/custom-playlists/$id'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'bio': bio,
              'coverArtUrl': coverArtUrl,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        _handleError(response, 'Failed to update playlist');
      }

      final json = jsonDecode(response.body)['data'];
      return _parsePlaylist(json);
    });
  }

  Future<void> deletePlaylist(String id) async {
    return _execute(() async {
      final response = await _client
          .delete(
            Uri.parse('$_baseUrl/api/v1/custom-playlists/$id'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        _handleError(response, 'Failed to delete playlist');
      }
    });
  }
}
