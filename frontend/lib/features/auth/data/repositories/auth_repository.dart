import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';

class AuthRepository {
  AuthRepository({required this.client, required this.prefs, String? baseUrl})
    : _baseUrl = baseUrl ?? AppConstants.apiBaseUrl;

  final http.Client client;
  final SharedPreferences prefs;
  final String _baseUrl;

  String? getToken() => prefs.getString('jwt_token');

  Future<T> _request<T>(Future<http.Response> Function() action) async {
    try {
      final res = await action();
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body) as T;
      } else {
        final body = jsonDecode(res.body);
        throw ServerException(
          message: body['message'] ?? AuthStrings.authFailed,
          statusCode: res.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: '${GeneralStrings.networkErrorPrefix}${e.toString()}');
    }
  }

  Future<void> login(String email, String password) async {
    final loginResponse = await _request<Map<String, dynamic>>(
      () => client.post(
        Uri.parse('$_baseUrl/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
    final payload = loginResponse['data'];
    await prefs.setString('jwt_token', payload['token']);
    await prefs.setString('user_id', payload['user']['id']);
    await prefs.setString('username', payload['user']['username']);
  }

  Future<void> register(String username, String email, String password) async {
    await _request<Map<String, dynamic>>(
      () => client.post(
        Uri.parse('$_baseUrl/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      ),
    );
  }

  Future<void> verifyEmail(String email, String otp) async {
    final verifyResponse = await _request<Map<String, dynamic>>(
      () => client.post(
        Uri.parse('$_baseUrl/api/v1/auth/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      ),
    );
    final payload = verifyResponse['data'];
    await prefs.setString('jwt_token', payload['token']);
    await prefs.setString('user_id', payload['user']['id']);
    await prefs.setString('username', payload['user']['username']);
  }

  Future<void> forgotPassword(String email) async {
    await _request<Map<String, dynamic>>(
      () => client.post(
        Uri.parse('$_baseUrl/api/v1/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ),
    );
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    await _request<Map<String, dynamic>>(
      () => client.post(
        Uri.parse('$_baseUrl/api/v1/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp, 'newPassword': newPassword}),
      ),
    );
  }

  Future<void> logout() async {
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('stream_quality');
    await prefs.remove('filter_explicit');
  }

  bool get isLoggedIn => getToken() != null;
  String? get currentUsername => prefs.getString('username');
}
