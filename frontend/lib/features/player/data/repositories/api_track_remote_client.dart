import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_prefs_keys.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/track.dart';
import '../datasources/track_mapper.dart';

class ApiTrackRemoteClient {
  const ApiTrackRemoteClient(this.client, this.baseUrl, this.prefs);

  final http.Client client;
  final String baseUrl;
  final SharedPreferences? prefs;

  Future<List<Track>> searchByVibe(String vibe, int offset) async {
    final isLoggedIn = prefs?.getString('jwt_token') != null;
    final requestedKbps = isLoggedIn ? (prefs?.getInt(AppPrefsKeys.playbackQuality) ?? 128) : 128;
    final limit = requestedKbps == 64 ? 20 : (requestedKbps == 256 ? 50 : 25);
    final hideExplicit = prefs?.getBool(AppPrefsKeys.hideExplicit) ?? false;
    final explicitAllowed = !hideExplicit;

    final response = await client
        .get(
          Uri.parse(
            '$baseUrl/api/v1/tracks/search?term=${Uri.encodeComponent(vibe)}&limit=$limit&quality=$requestedKbps&offset=$offset&explicit=$explicitAllowed',
          ),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw ServerException(
        message: body['message'] ?? GeneralStrings.unknownApiError,
        statusCode: response.statusCode,
      );
    }

    final responseBody = response.body;

    return Isolate.run(() {
      final body = jsonDecode(responseBody) as Map<String, dynamic>;
      final trackList = body['data'] as List<dynamic>? ?? [];

      return trackList
          .cast<Map<String, dynamic>>()
          .map(TrackMapper.fromJson)
          .toList(growable: false);
    });
  }

  Future<dynamic> get(String path, {bool withQuality = true}) async {
    final hideExplicit = prefs?.getBool(AppPrefsKeys.hideExplicit) ?? false;
    final explicitAllowed = !hideExplicit;
    final isLoggedIn = prefs?.getString('jwt_token') != null;
    final requestedKbps = isLoggedIn ? (prefs?.getInt(AppPrefsKeys.playbackQuality) ?? 128) : 128;

    final separator = path.contains('?') ? '&' : '?';
    var url = '$baseUrl$path${separator}explicit=$explicitAllowed';
    if (withQuality) url += '&quality=$requestedKbps';

    final deviceId = prefs?.getString('device_id') ?? '';
    final token = prefs?.getString('jwt_token');
    final headers = <String, String>{};
    if (deviceId.isNotEmpty) headers['X-Device-ID'] = deviceId;
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';

    try {
      final response = await client
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw ServerException(
        message: body['message'] ?? GeneralStrings.unknownApiError,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: '${GeneralStrings.networkErrorPrefix}${e.toString()}');
    }
  }

  Future<dynamic> getData(String path, {bool withQuality = true}) async {
    final decoded = await get(path, withQuality: withQuality);
    return decoded['data'];
  }
}

