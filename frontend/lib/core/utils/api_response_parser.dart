import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/general_strings.dart';
import '../errors/exceptions.dart';

/// Centralized, resilient HTTP response parser that prevents raw format exceptions.
abstract final class ApiResponseParser {
  /// Safely parses JSON map from http.Response, mapping HTTP error status codes
  /// to domain AppExceptions.
  static Map<String, dynamic> parseJsonResponse(http.Response response) {
    if (response.statusCode >= 500) {
      throw const InternalException(
        message: GeneralStrings.serverUnavailable,
        statusCode: 500,
      );
    }

    final decoded = _tryDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw InternalException(
        message: GeneralStrings.invalidServerResponse,
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 400) {
      _throwMappedError(response.statusCode, decoded);
    }

    return decoded;
  }

  static dynamic _tryDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  static void _throwMappedError(int status, Map<String, dynamic> body) {
    final message = body['message'] as String? ?? GeneralStrings.unknownApiError;
    switch (status) {
      case 401:
        throw AuthException(message: message);
      case 403:
        throw ForbiddenException(message: message);
      case 404:
        throw NotFoundException(message: message);
      case 409:
        throw ConflictException(message: message);
      case 422:
        throw ValidationException(message: message);
      default:
        throw InternalException(message: message, statusCode: status);
    }
  }
}
