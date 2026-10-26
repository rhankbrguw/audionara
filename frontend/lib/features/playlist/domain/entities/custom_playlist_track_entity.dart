import 'package:isar/isar.dart';

part 'custom_playlist_track_entity.g.dart';

@collection
class CustomPlaylistTrackEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  late String playlistId;

  late String trackId;
  late String title;
  late String artist;
  late String streamUrl;
  late String coverArt;
  late String artistId;
  late String albumId;

  @Index()
  late DateTime addedAt;
}
