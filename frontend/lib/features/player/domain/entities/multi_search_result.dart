import 'track.dart';

class TopResultItem {
  final String type;
  final String id;
  final String title;
  final String subtitle;
  final String coverArt;
  final String artist;
  final String artistId;
  final String albumId;
  final int durationMs;
  final bool isExplicit;

  const TopResultItem({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.coverArt,
    this.artist = '',
    this.artistId = '',
    this.albumId = '',
    this.durationMs = 0,
    this.isExplicit = false,
  });

  Track toTrack() => Track(
        id: id,
        title: title,
        artist: artist.isNotEmpty ? artist : subtitle,
        streamUrl: '',
        coverArt: coverArt,
        durationMs: durationMs,
        artistId: artistId,
        albumId: albumId,
        isExplicit: isExplicit,
      );
}

class MultiSearchResult {
  final TopResultItem? topResult;
  final List<Track> songs;
  final List<Track> artists;
  final List<Track> albums;

  const MultiSearchResult({
    this.topResult,
    required this.songs,
    required this.artists,
    required this.albums,
  });

  factory MultiSearchResult.empty() {
    return const MultiSearchResult(songs: [], artists: [], albums: []);
  }
}

