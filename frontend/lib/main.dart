import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'package:go_router/go_router.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/database/isar_database.dart';
import 'core/network/auth_client.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'app_bloc_providers.dart';
import 'core/errors/error_boundary.dart';
import 'core/widgets/error_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarDividerColor: AppColors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  ErrorBoundary.initialize();
  await IsarDatabase.initialize();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => AudioNaraApp(prefs: prefs),
    ),
  );
}

class AudioNaraApp extends StatefulWidget {
  const AudioNaraApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<AudioNaraApp> createState() => _AudioNaraAppState();
}

class _AudioNaraAppState extends State<AudioNaraApp> {
  late final http.Client _httpClient;
  late final AuthClient _authClient;
  late final AuthRepository _authRepo;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _httpClient = http.Client();
    _authClient = AuthClient(_httpClient, widget.prefs);
    _authRepo = AuthRepository(client: _httpClient, prefs: widget.prefs);
    _router = buildAppRouter(widget.prefs);
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocProviders(
      prefs: widget.prefs,
      authRepo: _authRepo,
      authClient: _authClient,
      httpClient: _httpClient,
      child: MaterialApp.router(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        title: 'AudioNara',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        routerConfig: _router,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
          },
        ),
      ),
    );
  }
}
