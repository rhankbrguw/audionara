import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/custom_playlist_entity.dart';
import '../../domain/entities/custom_playlist_track_entity.dart';
part 'custom_playlist_repository_api.dart';
part 'custom_playlist_repository_crud.dart';

class CustomPlaylistRepository {
  CustomPlaylistRepository({
    http.Client? client,
    String? baseUrl,
    required SharedPreferences prefs,
  }) : _client = client ?? http.Client(),
       _prefs = prefs,
       _baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  final http.Client _client;
  final SharedPreferences _prefs;
  final String _baseUrl;

  String get _userId => _prefs.getString('user_id') ?? 'guest';
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-User-Id': _userId,
  };

  Never _handleError(http.Response response, String fallbackMessage) {
    try {
      final body = jsonDecode(response.body);
      throw ServerException(
        message: body['message'] ?? fallbackMessage,
        statusCode: response.statusCode,
      );
    } catch (_) {
      throw ServerException(
        message: fallbackMessage,
        statusCode: response.statusCode,
      );
    }
  }

  Future<T> _execute<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: '${GeneralStrings.networkErrorPrefix}${e.toString()}');
    }
  }

  Future<String> uploadCoverArt(String filePath) async {
    return _execute(() async {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/v1/upload'),
      );
      request.headers['X-User-Id'] = _userId;
      final token = _prefs.getString('jwt_token');
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse = await _client
          .send(request)
          .timeout(const Duration(seconds: 10));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 201) {
        _handleError(response, 'Failed to upload cover art');
      }

      final uploadPayload = jsonDecode(response.body)['data'];
      return uploadPayload['url'] as String;
    });
  }
}
