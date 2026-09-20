import 'package:isar/isar.dart';

part 'recently_played_entity.g.dart';

@collection
class RecentlyPlayedEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String trackId;

  late String title;
  late String artist;
  late String streamUrl;
  late String coverArt;
  late String artistId;
  late String albumId;

  @Index()
  late DateTime lastPlayedAt;
}
