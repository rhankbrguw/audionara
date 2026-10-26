import 'package:isar/isar.dart';
import '../../domain/entities/recently_played_entity.dart';
import '../../../../core/database/isar_database.dart';
import '../../domain/entities/track.dart';

class RecentlyPlayedService {
  final Isar _isar = IsarDatabase.instance;
  static const int _maxRecentTracks = 20;

  Future<void> addTrack(Track track) async {
    final entity = RecentlyPlayedEntity()
      ..trackId = track.id
      ..title = track.title
      ..artist = track.artist
      ..streamUrl = track.streamUrl
      ..coverArt = track.coverArt
      ..artistId = track.artistId
      ..albumId = track.albumId
      ..lastPlayedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.collection<RecentlyPlayedEntity>().put(entity);

      // Cleanup older tracks
      final count = await _isar.collection<RecentlyPlayedEntity>().count();
      if (count > _maxRecentTracks) {
        final oldestTracks = await _isar
            .collection<RecentlyPlayedEntity>()
            .where()
            .sortByLastPlayedAt()
            .limit(count - _maxRecentTracks)
            .findAll();

        for (var old in oldestTracks) {
          await _isar.collection<RecentlyPlayedEntity>().delete(old.id);
        }
      }
    });
  }

  Stream<List<RecentlyPlayedEntity>> watchRecentlyPlayed() {
    return _isar
        .collection<RecentlyPlayedEntity>()
        .where()
        .sortByLastPlayedAtDesc()
        .limit(10)
        .watch(fireImmediately: true);
  }
}
