/// Centralised SharedPreferences key registry.
///
/// All prefs keys must be defined here to avoid typo bugs and key collisions.
abstract final class AppPrefsKeys {
  static const String recentSearches = 'recent_searches';
  static const String authToken = 'auth_token';
  static const String userId = 'user_id';
  static const String playbackQuality = 'playback_quality';
  static const String hideExplicit = 'hide_explicit';
}
