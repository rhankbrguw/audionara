class AlbumRouteExtra {
  final String id;
  final String coverArt;
  final String title;
  final String artist;
  const AlbumRouteExtra({
    required this.id,
    required this.coverArt,
    required this.title,
    required this.artist,
  });
}

class ArtistRouteExtra {
  final String id;
  final String name;
  final String genre;
  const ArtistRouteExtra({
    required this.id,
    required this.name,
    required this.genre,
  });
}

class TrendingRouteExtra {
  final String title;
  final String subtitle;
  final String badge;
  final int color1;
  final int color2;
  final String cover;

  const TrendingRouteExtra({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color1,
    required this.color2,
    this.cover = '',
  });
}

class ArtistDiscographyRouteExtra {
  final String artistName;
  final dynamic albums;
  final int initialTabIndex;

  const ArtistDiscographyRouteExtra({
    required this.artistName,
    required this.albums,
    this.initialTabIndex = 0,
  });
}
