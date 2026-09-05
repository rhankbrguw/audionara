abstract final class PlayerStrings {
  static const String addToPlaylist = 'Add to Playlist';
  static const String toggledInPlaylist = 'Toggled in Playlist';
  static const String viewArtist = 'View Artist';
  static const String artistRouteComingSoon = 'Artist route coming soon';
  static const String audioQuality = 'Audio Quality';
  static const String hiResLossless = 'Lossless';
  static const String audioQualityComingSoon =
        'Audio quality options coming soon';
  static const String sleepTimerComingSoon = 'Sleep timer coming soon';
  static const String playbackQuality = 'Playback Quality';
  static const String qualityStandard = 'Standard (64 kbps)';
  static const String qualityHigh = 'High (128 kbps)';
  static const String qualityLossless = 'Lossless (256 kbps)';
  static const String qualityStandardDesc = 'Saves data, lower fidelity';
  static const String qualityHighDesc = 'Balanced quality';
  static const String qualityLosslessDesc = 'Full fidelity, uses more data';
  static String qualitySet(String quality) =>
        'Quality set to $quality. Takes effect on next search.';
  static const String sleepTimerTitle = 'Sleep Timer';
  static const String sleepTimerDesc = 'Stop playing music after...';
  static const String timerCanceled = 'Sleep timer canceled';
  static const String shuffleEnabled = 'Shuffle enabled';
  static const String shuffleDisabled = 'Shuffle disabled';
  static const String repeatEnabled = 'Repeat enabled';
  static const String repeatDisabled = 'Repeat disabled';
  static const String cancelTimer = 'Cancel Timer';
  static const String startTimer = 'Start Timer';
  static const String lyricsTitle = 'Lyrics';
  static const String noLyricsAvailable = 'No lyrics available';
  static String sleepTimerRemaining(int m) => '${m}m';
  static const String playbackError = 'Playback Error: ';
  static const String nowPlaying = 'Now Playing';
}
