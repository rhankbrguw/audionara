import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/track.dart';
import '../../domain/entities/multi_search_result.dart';
import '../../domain/entities/album_detail.dart';
import '../../domain/entities/album_meta.dart';
import '../../domain/entities/artist_detail.dart';
import '../../domain/repositories/track_repository.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/track_mapper.dart';
import 'api_track_remote_client.dart';

class ApiTrackRepository implements TrackRepository {
  ApiTrackRepository({
    http.Client? client,
    String? baseUrl,
    SharedPreferences? prefs,
  }) : _client = client ?? http.Client(),
       _prefs = prefs,
       _baseUrl = baseUrl ?? AppConstants.apiBaseUrl {
    _remoteClient = ApiTrackRemoteClient(_client, _baseUrl, _prefs);
  }

  final http.Client _client;
  final String _baseUrl;
  final SharedPreferences? _prefs;
  late final ApiTrackRemoteClient _remoteClient;

  @override
  Future<Track> findById(String id) async {
    final results = await _remoteClient.searchByVibe(id, 0);
    if (results.isEmpty) throw NotFoundException(message: 'Track not found: $id');
    return results.first;
  }

  @override
  Future<List<Track>> findAll() =>
      throw UnimplementedError('Use searchByVibe for catalogue queries.');

  @override
  Future<List<Track>> searchByVibe(String vibe, {int offset = 0}) =>
      _remoteClient.searchByVibe(vibe, offset);

  @override
  Future<List<Track>> fetchMixForYou() async {
    final data = await _remoteClient.getData('/api/v1/tracks/mix');
    if (data == null) return [];
    return (data as List).map((e) => TrackMapper.fromJson(e)).toList();
  }

  @override
  Future<List<Track>> searchRaw(String query, {int offset = 0}) async {
    final data = await _remoteClient.getData('/api/v1/tracks/search/raw?q=${Uri.encodeComponent(query)}&offset=$offset');
    if (data == null) return [];
    return (data as List).map((e) => TrackMapper.fromJson(e)).toList();
  }

  @override
  Future<MultiSearchResult> searchMulti(String query) async {
    final data = await _remoteClient.getData('/api/v1/tracks/search/multi?q=${Uri.encodeComponent(query)}');
    final payload = data as Map<String, dynamic>?;
    if (payload == null) return MultiSearchResult.empty();

    return MultiSearchResult(
      topResult: TrackMapper.topResultFromJson(payload['top_result'] as Map<String, dynamic>?),
      songs: (payload['songs'] as List?)?.map((e) => TrackMapper.fromJson(e)).toList() ?? [],
      artists: (payload['artists'] as List?)?.map((e) => TrackMapper.fromJson(e)).toList() ?? [],
      albums: (payload['albums'] as List?)?.map((e) => TrackMapper.fromJson(e)).toList() ?? [],
    );
  }

  @override
  Future<void> recordPlaybackMetric(String trackId, String vibe, String action) async {
    try {
      final deviceId = _prefs?.getString('device_id') ?? '';
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (deviceId.isNotEmpty) {
        headers['X-Device-ID'] = deviceId;
      }
      await _client.post(
        Uri.parse('$_baseUrl/api/v1/tracks/metrics'),
        headers: headers,
        body: jsonEncode({'track_id': trackId, 'vibe': vibe, 'action': action}),
      ).timeout(const Duration(seconds: 5));
    } catch (_) {
      // Best-effort metric recording
    }
  }

  @override
  Future<void> logHistory(Track track) async {
    try {
      final deviceId = _prefs?.getString('device_id') ?? '';
      final token = _prefs?.getString('jwt_token');
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (deviceId.isNotEmpty) {
        headers['X-Device-ID'] = deviceId;
      }
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      await _client.post(
        Uri.parse('$_baseUrl/api/v1/tracks/history'),
        headers: headers,
        body: jsonEncode({'track_id': track.id, 'title': track.title, 'artist': track.artist, 'genre': ''}),
      ).timeout(const Duration(seconds: 5));
    } catch (_) {
      // Best-effort history logging
    }
  }

  @override
  Future<AlbumDetail> getAlbumDetail(String albumId) async {
    final data = await _remoteClient.getData('/api/v1/albums/$albumId/tracks');
    return AlbumDetail(
      meta: AlbumMeta.fromJson(data['meta']),
      tracks: (data['tracks'] as List).map((e) => TrackMapper.fromJson(e)).toList(),
    );
  }

  @override
  Future<List<Track>> getArtistTopSongs(String artistId) async {
    final data = await _remoteClient.getData('/api/v1/artists/$artistId/tracks');
    if (data == null) return [];
    return (data as List).map((e) => TrackMapper.fromJson(e)).toList();
  }

  @override
  Future<ArtistDetail> getArtistDetail(String artistId) async {
    final data = await _remoteClient.getData('/api/v1/artists/$artistId/detail');
    return ArtistDetail.fromJson(data as Map<String, dynamic>);
  }
}
