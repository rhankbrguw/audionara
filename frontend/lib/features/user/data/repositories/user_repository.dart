import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';

class UserRepository {
  UserRepository({required this.client, required this.prefs, String? baseUrl})
    : _baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  final http.Client client;
  final SharedPreferences prefs;
  final String _baseUrl;

  String? get _userId => prefs.getString('user_id');
  String? get _token => prefs.getString('jwt_token');

  Map<String, String> get _headers {
    final map = {'Content-Type': 'application/json'};
    final token = _token;
    if (token != null && token.isNotEmpty) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
  }

  Future<T> _request<T>(Future<http.Response> Function() action) async {
    try {
      final res = await action();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body) as T;
      } else {
        final body = jsonDecode(res.body);
        throw ServerException(
          message: body['message'] ?? GeneralStrings.requestFailed,
          statusCode: res.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(
        message: '${GeneralStrings.networkErrorPrefix}${e.toString()}',
      );
    }
  }

  Future<UserEntity> getProfile() async {
    final profileResponse = await _request<Map<String, dynamic>>(
      () =>
          client.get(Uri.parse('$_baseUrl/api/v1/profile'), headers: _headers),
    );
    return UserEntity.fromJson(profileResponse['data']);
  }

  Future<UserEntity> updateProfile(
    String bio,
    String profilePictureFilePath, {
    String username = '',
    String email = '',
    String existingProfilePictureUrl = '',
  }) async {
    String profilePictureUrl = existingProfilePictureUrl;

    if (profilePictureFilePath.isNotEmpty) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/v1/upload'),
      );
      if (_token != null) request.headers['Authorization'] = 'Bearer $_token';
      request.headers['X-User-Id'] = _userId ?? 'guest';
      request.files.add(
        await http.MultipartFile.fromPath('file', profilePictureFilePath),
      );

      final streamedResponse = await client
          .send(request)
          .timeout(const Duration(seconds: 10));
      final res = await http.Response.fromStream(streamedResponse);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final uploadPayload = jsonDecode(res.body)['data'];
        profilePictureUrl = uploadPayload['url'];
      } else {
        throw ServerException(
          message: 'Failed to upload image',
          statusCode: res.statusCode,
        );
      }
    }

    final payload = <String, dynamic>{
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
    };
    if (username.isNotEmpty) payload['username'] = username;
    if (email.isNotEmpty) payload['email'] = email;

    final updateResponse = await _request<Map<String, dynamic>>(
      () => client.put(
        Uri.parse('$_baseUrl/api/v1/profile'),
        headers: _headers,
        body: jsonEncode(payload),
      ),
    );

    if (username.isNotEmpty) {
      await prefs.setString('username', username);
    }
    return UserEntity.fromJson(updateResponse['data']);
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _request<Map<String, dynamic>>(
      () => client.post(
        Uri.parse('$_baseUrl/api/v1/profile/change-password'),
        headers: _headers,
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      ),
    );
  }
}
