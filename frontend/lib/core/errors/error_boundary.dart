import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class ErrorBoundary {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      developer.log(details.exceptionAsString(), name: 'ErrorBoundary');
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      developer.log('$error', stackTrace: stack, name: 'ErrorBoundary');
      return true;
    };
  }
}
