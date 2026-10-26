import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/home/presentation/pages/album_detail_page.dart';
import '../../features/home/presentation/pages/artist_detail_page.dart';
import '../../features/player/presentation/pages/player_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/edit_profile_page.dart';
import '../../features/user/domain/entities/user_entity.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_otp_page.dart';
import '../../features/playlist/presentation/pages/playlists_page.dart';
import '../../features/playlist/presentation/pages/create_playlist_page.dart';
import '../../features/playlist/presentation/pages/playlist_details_page.dart';
import '../../features/playlist/presentation/pages/edit_playlist_page.dart';
import '../../features/playlist/domain/entities/custom_playlist_entity.dart';
import '../../features/home/presentation/pages/favourites_page.dart';
import '../../features/home/presentation/pages/trending_detail_page.dart';
import '../../features/home/presentation/pages/artist_discography_page.dart';
import '../../core/theme/app_colors.dart';
import 'page_transitions.dart';
import 'route_extras.dart';

export 'route_extras.dart';

GoRouter buildAppRouter(SharedPreferences prefs) => GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(path: '/', name: 'splash', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const SplashScreen())),
    GoRoute(path: '/home', name: 'home', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const HomePage())),
    GoRoute(path: '/settings', name: 'settings', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const SettingsPage())),
    GoRoute(
      path: '/edit-profile',
      name: 'editProfile',
      pageBuilder: (c, s) => AppPageTransitions.slideFade(
        state: s,
        child: EditProfilePage(user: s.extra as UserEntity),
      ),
    ),
    GoRoute(path: '/player', name: 'player', pageBuilder: (c, s) => AppPageTransitions.modalSheet(state: s, child: const PlayerPage())),
    GoRoute(path: '/login', name: 'login', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const LoginPage())),
    GoRoute(path: '/register', name: 'register', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const RegisterPage())),
    GoRoute(path: '/verify-email', name: 'verifyEmail', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: OtpVerificationPage(email: s.extra as String? ?? ''))),
    GoRoute(path: '/forgot-password', name: 'forgotPassword', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const ForgotPasswordPage())),
    GoRoute(path: '/reset-password-otp', name: 'resetPasswordOtp', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: ResetPasswordOtpPage(email: s.extra as String? ?? ''))),
    GoRoute(path: '/playlists', name: 'playlists', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const PlaylistsPage())),
    GoRoute(path: '/create-playlist', name: 'createPlaylist', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const CreatePlaylistPage())),
    GoRoute(path: '/playlist/:id', name: 'playlistDetails', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: PlaylistDetailsPage(playlist: s.extra as CustomPlaylistEntity))),
    GoRoute(path: '/edit-playlist', name: 'editPlaylist', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: EditPlaylistPage(playlist: s.extra as CustomPlaylistEntity))),
    GoRoute(path: '/favourites', name: 'favourites', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: const FavouritesPage())),
    GoRoute(path: '/search', name: 'search', pageBuilder: (c, s) => AppPageTransitions.slideFade(state: s, child: SearchPage(query: s.uri.queryParameters['q'] ?? ''))),
    GoRoute(
      path: '/album/:id',
      name: 'albumDetail',
      pageBuilder: (c, s) {
        final ext = s.extra as AlbumRouteExtra?;
        return AppPageTransitions.slideFade(
          state: s,
          child: AlbumDetailPage(
            albumId: s.pathParameters['id']!,
            initialCoverArt: ext?.coverArt,
            initialTitle: ext?.title,
            initialArtist: ext?.artist,
          ),
        );
      },
    ),
    GoRoute(
      path: '/artist/:id',
      name: 'artistDetail',
      pageBuilder: (c, s) {
        final ext = s.extra as ArtistRouteExtra?;
        return AppPageTransitions.slideFade(
          state: s,
          child: ArtistDetailPage(artistId: s.pathParameters['id']!, artistName: ext?.name ?? '', genre: ext?.genre ?? ''),
        );
      },
    ),
    GoRoute(
      path: '/artist/:id/discography',
      name: 'artistDiscography',
      pageBuilder: (c, s) {
        final ext = s.extra as ArtistDiscographyRouteExtra;
        return AppPageTransitions.slideFade(
          state: s,
          child: ArtistDiscographyPage(
            artistName: ext.artistName,
            albums: ext.albums,
            initialTabIndex: ext.initialTabIndex,
          ),
        );
      },
    ),
    GoRoute(
      path: '/trending/:id',
      name: 'trendingDetail',
      pageBuilder: (c, s) {
        final ext = s.extra as TrendingRouteExtra?;
        return AppPageTransitions.slideFade(
          state: s,
          child: TrendingDetailPage(
            vibeName: s.pathParameters['id']!,
            title: ext?.title ?? s.pathParameters['id']!,
            subtitle: ext?.subtitle ?? '',
            badge: ext?.badge ?? '',
            color1: ext != null ? Color(ext.color1) : AppColors.primary,
            color2: ext != null ? Color(ext.color2) : AppColors.secondary,
            cover: ext?.cover ?? '',
          ),
        );
      },
    ),
  ],
);
