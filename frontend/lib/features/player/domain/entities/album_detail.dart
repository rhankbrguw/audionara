import 'album_meta.dart';
import 'track.dart';

/// Full album detail entity: metadata + list of tracks.
class AlbumDetail {
  final AlbumMeta meta;
  final List<Track> tracks;

  const AlbumDetail({required this.meta, required this.tracks});

  /// Total runtime of the album in milliseconds.
  int get totalDurationMs => tracks.fold(0, (sum, t) => sum + t.durationMs);
}
