import 'dart:io';

abstract final class AppConstants {
  static const commonEmailTypos = [
    '@gmail.co', '@gmail.con', '@gmai.com', '@gmal.com',
    '@yahoo.co', '@yahoo.con', '@hotmail.co', '@hotmail.con',
  ];

  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;

    if (const bool.fromEnvironment('dart.vm.product')) {
      return 'https://api-audionara.rhankbrguw.xyz';
    }

    return Platform.isAndroid
        ? 'http://10.0.2.2:8080'
        : 'http://127.0.0.1:8080';
  }
}
