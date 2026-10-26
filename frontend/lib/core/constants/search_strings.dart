abstract final class SearchStrings {
  static const String searchByVibe = 'Search by vibe...';
  static const String searchHint = 'Search songs, artists, albums...';
  static const String recentSearchesLabel = 'Recent Searches';
  static const String clearAll = 'Clear All';
  static const String searchPrompt =
      'No recent searches yet. Try to search for your favorite tracks.';
  static const String fansAlsoLike = 'Fans Also Like';
  static const String noResultsFound = 'No results found.';
  static const String searchSongs = 'Songs';
  static const String searchArtists = 'Artists';
  static const String searchAlbums = 'Albums';
  static const String topResult = 'Top Result';
  static const String songBadge = 'SONG';
  static const String artistBadge = 'ARTIST';
  static const String albumBadge = 'ALBUM';

  static const List<String> discoveryNarratives = [
    'Trending Artists For You',
    'Artists You Might Love',
    'Discover New Favorites',
    'Similar Tastes & Soundscapes',
  ];

  static String becauseYouListen(String artist, {int seed = 0}) {
    final trimmed = artist.trim();
    if (trimmed.isEmpty) {
      return discoveryNarratives[seed.abs() % discoveryNarratives.length];
    }
    final templates = [
      'Because you listen to $trimmed',
      'Fans of $trimmed also love',
      'Similar vibes to $trimmed',
      'Inspired by your taste in $trimmed',
      'More like $trimmed',
      'You might like alongside $trimmed',
    ];
    return templates[seed.abs() % templates.length];
  }
}

