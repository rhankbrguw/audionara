import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/playlist_item.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';

class PlaylistRepository {
  PlaylistRepository({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  Future<bool> toggleTrack(PlaylistItem item) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/v1/playlist/toggle'),
            headers: _headers,
            body: jsonEncode({
              'trackId': item.trackId,
              'title': item.title,
              'artist': item.artist,
              'streamUrl': item.streamUrl,
              'coverArt': item.coverArt,
              'artistId': item.artistId,
              'albumId': item.albumId,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to toggle favourite.',
          statusCode: response.statusCode,
        );
      }

      final payload = jsonDecode(response.body)['data'];
      return payload['isSaved'] as bool;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const NetworkException(message: 'Could not reach the server.');
    }
  }

  Future<bool> isTrackSaved(String trackId) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/api/v1/playlist/status?trackId=$trackId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) return false;
      final payload = jsonDecode(response.body)['data'];
      return payload['isSaved'] as bool;
    } catch (_) {
      return false;
    }
  }

  Future<List<PlaylistItem>> getAllSavedTracks() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/api/v1/playlist'), headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to load favourites.',
          statusCode: response.statusCode,
        );
      }

      final tracksPayload = jsonDecode(response.body)['data'] as List<dynamic>?;
      if (tracksPayload == null) return [];

      return tracksPayload.map((json) {
        return PlaylistItem()
          ..trackId = json['trackId']
          ..title = json['title']
          ..artist = json['artist']
          ..streamUrl = json['streamUrl'] ?? ''
          ..coverArt = json['coverArt'] ?? ''
          ..artistId = json['artistId'] ?? ''
          ..albumId = json['albumId'] ?? ''
          ..addedAt = DateTime.parse(json['addedAt']);
      }).toList();
    } on ServerException {
      rethrow;
    } catch (_) {
      throw const NetworkException(message: 'Could not reach the server.');
    }
  }
}
