/// Base domain exception for the application.
abstract class AppException implements Exception {
  final String message;
  final String code;
  final int statusCode;

  const AppException({
    required this.message,
    this.code = 'INTERNAL_ERROR',
    this.statusCode = 500,
  });

  @override
  String toString() => '$runtimeType(code: $code, message: $message)';
}

class ValidationException extends AppException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
    super.statusCode = 422,
  });
}

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'UNAUTHENTICATED',
    super.statusCode = 401,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    required super.message,
    super.code = 'UNAUTHORIZED',
    super.statusCode = 403,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code = 'NOT_FOUND',
    super.statusCode = 404,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    required super.message,
    super.code = 'CONFLICT',
    super.statusCode = 409,
  });
}

class InternalException extends AppException {
  const InternalException({
    required super.message,
    super.code = 'INTERNAL_ERROR',
    super.statusCode = 500,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Unable to connect to the server. Please check your internet connection.',
    super.code = 'NETWORK_ERROR',
    super.statusCode = 0,
  });
}

class PlaybackException extends AppException {
  const PlaybackException({
    required super.message,
    super.code = 'PLAYBACK_ERROR',
    super.statusCode = 0,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.statusCode = 0,
  });
}

// Backward compatibility alias
typedef ServerException = InternalException;
