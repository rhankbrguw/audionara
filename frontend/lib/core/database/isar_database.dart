import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/playlist/domain/entities/playlist_item.dart';
import '../../features/playlist/domain/entities/custom_playlist_entity.dart';
import '../../features/playlist/domain/entities/custom_playlist_track_entity.dart';
import '../../features/player/domain/entities/recently_played_entity.dart';

/// IsarDatabase manages the local Isar database instance and schema.
class IsarDatabase {
  static late Isar _instance;

  /// Returns the globally initialized Isar instance.
  static Isar get instance => _instance;

  /// Initializes the Isar database, opening the required schemas.
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open([
      PlaylistItemSchema,
      CustomPlaylistEntitySchema,
      CustomPlaylistTrackEntitySchema,
      RecentlyPlayedEntitySchema,
    ], directory: dir.path);
  }
}
