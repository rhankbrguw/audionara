abstract final class SearchStrings {
  static const String searchByVibe = 'Search by vibe...';
  static const String searchHint = 'Search songs, artists, albums...';
  static const String recentSearchesLabel = 'Recent Searches';
  static const String clearAll = 'Clear All';
  static const String searchPrompt =
      'No recent searches yet. Try to search for your favorite tracks.';
  static const String fansAlsoLike = 'Fans Also Like';
  static String becauseYouListen(String artist) =>
      artist.trim().isEmpty ? fansAlsoLike : 'Because you listen to $artist';
  static const String noResultsFound = 'No results found.';
  static const String searchSongs = 'Songs';
  static const String searchArtists = 'Artists';
  static const String searchAlbums = 'Albums';
  static const String topResult = 'Top Result';
  static const String songBadge = 'SONG';
  static const String artistBadge = 'ARTIST';
  static const String albumBadge = 'ALBUM';
}

