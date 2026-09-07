abstract final class GeneralStrings {
  static const String noTracksFound = 'No tracks found for this vibe.';
  static const String noArtistTracksFound = 'No tracks found for this artist.';
  static const String couldNotLoadAlbum = 'Could not load album';
  static const String couldNotLoadArtist = 'Could not load artist songs';
  static const String playAll = 'Play All';
  static const String failedToLoadTrack = 'Failed to load track.';
  static const String initializing = 'Initializing...';
  static const String retry = 'Retry';
  static const String noRecentHistory = 'No recent history';
  static const String unexpectedError = 'An unexpected error occurred.';
  static String albumTracksDuration(int count, String duration) => '$count songs · $duration';
  static String trackArtist(String title, String artist) => '$title - $artist';
  static String trackIndex(int index) => '$index';
  
  // Network Error Strings
  static const String networkErrorPrefix = 'Network error: ';
  static const String unknownApiError = 'Unknown API error. Please try again.';
  static const String requestFailed = 'Request failed. Please check your connection.';
  static const String emailTypoMessage = 'Please check your email address for typos.';
  static String defaultVibeSubtitle(String name) => 'Essential $name tracks & playlists';
  static const String recordTypeSingle = 'Single';
  static const String recordTypeEp = 'EP';
  static const String recordTypeCompilation = 'Compilation';
  static const String recordTypeAlbum = 'Album';
  static String albumReleaseAndLabel(String year, String label) => '$year • $label';
  static String songCount(int count) => count == 1 ? '$count Song' : '$count Songs';
  static String recordTypeWithCount(String type, String count) => '$type · $count';
}
