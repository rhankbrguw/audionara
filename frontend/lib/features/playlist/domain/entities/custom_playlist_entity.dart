import 'package:isar/isar.dart';

part 'custom_playlist_entity.g.dart';

@collection
class CustomPlaylistEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  late String userId;
  late String name;
  late String bio;
  late String coverArtUrl;

  @Index()
  late DateTime createdAt;
}
