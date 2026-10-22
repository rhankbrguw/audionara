import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../errors/exceptions.dart';

/// AuthClient is a custom HTTP client that injects authentication tokens
/// and handles exponential backoff for retries.
class AuthClient extends http.BaseClient {
  AuthClient(this._inner, this._prefs);

  final http.Client _inner;
  final SharedPreferences _prefs;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1. Auto-Authentication & Device ID
    final token = _prefs.getString('jwt_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    var deviceId = _prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      _prefs.setString('device_id', deviceId);
    }
    request.headers['X-Device-ID'] = deviceId;

    // 2. Exponential Backoff Retry Logic
    int attempt = 0;
    const maxRetries = 3;

    while (attempt < maxRetries) {
      try {
        final copiedRequest = await _copyRequest(request);
        final response = await _inner.send(copiedRequest).timeout(const Duration(seconds: 12));
        
        if (response.statusCode >= 500 || response.statusCode == 429) {
          if (attempt == maxRetries - 1) return response;
          throw TimeoutException('Server error, retrying...');
        }
        
        return response;
      } on TimeoutException {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await _sleepForBackoff(attempt);
      } catch (_) {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await _sleepForBackoff(attempt);
      }
    }
    
    throw const NetworkException(message: 'Request failed after maximum retry attempts.');
  }

  Future<void> _sleepForBackoff(int attempt) async {
    final delay = (pow(2, attempt) * 1000).toInt() + Random().nextInt(500);
    await Future.delayed(Duration(milliseconds: delay));
  }

  Future<http.BaseRequest> _copyRequest(http.BaseRequest request) async {
    if (request is http.Request) {
      final copy = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
      copy.headers.addAll(request.headers);
      return copy;
    } else {
      return request;
    }
  }
}
