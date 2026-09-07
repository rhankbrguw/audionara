/// Dart mirror of the Go Track domain entity.
/// This PODO (Plain Old Dart Object) is the canonical representation of
/// a track throughout the Flutter app. No framework dependencies.
class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.streamUrl,
    required this.coverArt,
    this.durationMs = 0,
    this.trackNumber = 0,
    this.albumId = '',
    this.artistId = '',
    this.isExplicit = false,
  });

  final String id;
  final String title;
  final String artist;
  final String streamUrl;
  final String coverArt;
  final int durationMs;
  final int trackNumber;
  final String albumId;
  final String artistId;
  final bool isExplicit;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    artist: json['artist'] as String? ?? '',
    streamUrl: json['stream_url'] as String? ?? '',
    coverArt: json['cover_art'] as String? ?? '',
    durationMs: json['duration_ms'] as int? ?? 0,
    trackNumber: json['track_number'] as int? ?? 0,
    albumId: json['album_id'] as String? ?? '',
    artistId: json['artist_id'] as String? ?? '',
    isExplicit: json['is_explicit'] as bool? ?? false,
  );

  @override
  String toString() => 'Track(id: $id, title: $title, artist: $artist)';
}

