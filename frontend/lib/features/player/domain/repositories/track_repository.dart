import '../entities/track.dart';
import '../entities/multi_search_result.dart';
import '../entities/album_detail.dart';
import '../entities/artist_detail.dart';

/// Abstract contract for track data access.
/// Concrete implementations live in the data layer and are injected at runtime.
abstract class TrackRepository {
  Future<Track> findById(String id);
  Future<List<Track>> findAll();
  Future<List<Track>> searchByVibe(String vibe, {int offset = 0});
  Future<List<Track>> searchRaw(String query, {int offset = 0});
  Future<MultiSearchResult> searchMulti(String query);
  Future<List<Track>> fetchMixForYou();
  Future<void> recordPlaybackMetric(String trackId, String vibe, String action);
  Future<AlbumDetail> getAlbumDetail(String albumId);
  Future<List<Track>> getArtistTopSongs(String artistId);
  Future<ArtistDetail> getArtistDetail(String artistId);
  Future<void> logHistory(Track track);
}

