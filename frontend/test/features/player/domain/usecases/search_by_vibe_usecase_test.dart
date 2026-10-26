import 'package:flutter_test/flutter_test.dart';
import 'package:audionara/features/player/domain/entities/track.dart';
import 'package:audionara/features/player/domain/entities/multi_search_result.dart';
import 'package:audionara/features/player/domain/entities/album_detail.dart';
import 'package:audionara/features/player/domain/entities/artist_detail.dart';
import 'package:audionara/features/player/domain/repositories/track_repository.dart';

import 'package:audionara/features/player/domain/usecases/search_by_vibe_usecase.dart';

class FakeTrackRepository implements TrackRepository {
  List<Track> stubTracks = [];
  bool wasCalled = false;
  String? lastVibe;

  @override
  Future<List<Track>> searchByVibe(String vibe, {int offset = 0}) async {
    wasCalled = true;
    lastVibe = vibe;
    return stubTracks;
  }
  
  @override
  Future<Track> findById(String id) async => throw UnimplementedError();
  @override
  Future<List<Track>> findAll() async => throw UnimplementedError();
  @override
  Future<List<Track>> searchRaw(String query, {int offset = 0}) async => throw UnimplementedError();
  @override
  Future<MultiSearchResult> searchMulti(String query) async => throw UnimplementedError();
  @override
  Future<List<Track>> fetchMixForYou() async => throw UnimplementedError();
  @override
  Future<void> recordPlaybackMetric(String trackId, String vibe, String action) async {}
  @override
  Future<AlbumDetail> getAlbumDetail(String albumId) async => throw UnimplementedError();
  @override
  Future<List<Track>> getArtistTopSongs(String artistId) async => throw UnimplementedError();
  @override
  Future<ArtistDetail> getArtistDetail(String artistId) async => throw UnimplementedError();
  @override
  Future<void> logHistory(Track track) async {}

}


void main() {
  group('SearchByVibeUseCase', () {
    late SearchByVibeUseCase usecase;
    late FakeTrackRepository repo;

    setUp(() {
      repo = FakeTrackRepository();
      usecase = SearchByVibeUseCase(repository: repo);
    });

    test('calls searchByVibe on repository and returns tracks', () async {
      repo.stubTracks = const [
        Track(id: '1', title: 'Song 1', artist: 'Artist 1', streamUrl: 'url1', coverArt: 'cover1'),
      ];

      final result = await usecase('chill');

      expect(repo.wasCalled, isTrue);
      expect(repo.lastVibe, 'chill');
      expect(result.length, 1);
      expect(result.first.id, '1');
    });
  });
}
