/// Album metadata entity returned from the backend.
class AlbumMeta {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String coverArt;
  final String genre;
  final String year;
  final int trackCount;
  final String copyright;
  final String label;
  final String releaseDate;
  final String recordType;

  const AlbumMeta({
    required this.id,
    required this.title,
    required this.artist,
    this.artistId = '',
    required this.coverArt,
    required this.genre,
    required this.year,
    required this.trackCount,
    required this.copyright,
    this.label = '',
    this.releaseDate = '',
    this.recordType = 'album',
  });

  factory AlbumMeta.fromJson(Map<String, dynamic> json) => AlbumMeta(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    artist: json['artist'] as String? ?? '',
    artistId: json['artist_id'] as String? ?? '',
    coverArt: json['cover_art'] as String? ?? '',
    genre: json['genre'] as String? ?? '',
    year: json['year'] as String? ?? '',
    trackCount: json['track_count'] as int? ?? 0,
    copyright: json['copyright'] as String? ?? '',
    label: json['label'] as String? ?? '',
    releaseDate: json['release_date'] as String? ?? '',
    recordType: json['record_type'] as String? ?? 'album',
  );
}

