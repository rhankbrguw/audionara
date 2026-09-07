import 'album_meta.dart';
import 'track.dart';

/// Complete artist metadata entity including biography, history, and discography.
class ArtistDetail {
  final String id;
  final String name;
  final String picture;
  final String bio;
  final String history;
  final int fansCount;
  final int albumCount;
  final List<String> genres;
  final List<Track> topTracks;
  final List<AlbumMeta> albums;

  const ArtistDetail({
    required this.id,
    required this.name,
    required this.picture,
    required this.bio,
    required this.history,
    required this.fansCount,
    required this.albumCount,
    required this.genres,
    required this.topTracks,
    required this.albums,
  });

  factory ArtistDetail.fromJson(Map<String, dynamic> json) {
    final rawTop = json['top_tracks'] as List<dynamic>? ?? [];
    final rawAlbums = json['albums'] as List<dynamic>? ?? [];
    final rawGenres = json['genres'] as List<dynamic>? ?? [];

    return ArtistDetail(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      history: json['history'] as String? ?? '',
      fansCount: json['fans_count'] as int? ?? 0,
      albumCount: json['album_count'] as int? ?? 0,
      genres: rawGenres.map((g) => g.toString()).toList(),
      topTracks: rawTop
          .map((t) => Track.fromJson(t as Map<String, dynamic>))
          .toList(),
      albums: rawAlbums
          .map((a) => AlbumMeta.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}
