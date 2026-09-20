import '../../domain/entities/multi_search_result.dart';
import '../../domain/entities/track.dart';

class TrackMapper {
  static Track fromJson(Map<String, dynamic> json) => Track(
    id: json['id'] as String? ?? '',
    title: _cleanTitle(
      json['title'] as String? ?? '',
      json['artist'] as String? ?? '',
    ),
    artist: json['artist'] as String? ?? '',
    streamUrl: json['stream_url'] as String? ?? '',
    coverArt: json['cover_art'] as String? ?? '',
    durationMs: json['duration_ms'] as int? ?? 0,
    trackNumber: json['track_number'] as int? ?? 0,
    albumId: json['album_id'] as String? ?? '',
    artistId: json['artist_id'] as String? ?? '',
    isExplicit: json['is_explicit'] as bool? ?? false,
  );

  static TopResultItem? topResultFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return TopResultItem(
      type: json['type'] as String? ?? 'song',
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      coverArt: json['cover_art'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      artistId: json['artist_id'] as String? ?? '',
      albumId: json['album_id'] as String? ?? '',
      durationMs: json['duration_ms'] as int? ?? 0,
      isExplicit: json['is_explicit'] as bool? ?? false,
    );
  }

  static String _cleanTitle(String title, String artist) {
    if (artist.isEmpty || title.isEmpty) return title;
    final prefix = '$artist - ';
    final suffix = ' - $artist';
    if (title.toLowerCase().startsWith(prefix.toLowerCase())) {
      return title.substring(prefix.length).trim();
    }
    if (title.toLowerCase().endsWith(suffix.toLowerCase())) {
      return title.substring(0, title.length - suffix.length).trim();
    }
    return title;
  }
}

