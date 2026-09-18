import 'package:flutter/material.dart';
import '../../../playlist/domain/entities/playlist_item.dart';
import 'favourite_track_tile.dart';

class FavouritesTrackList extends StatelessWidget {
  final List<PlaylistItem> items;
  final void Function(int) onPlay;
  final void Function(PlaylistItem) onRemove;

  const FavouritesTrackList({
    super.key,
    required this.items,
    required this.onPlay,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FavouriteTrackTile(
          item: items[index],
          onTap: () => onPlay(index),
          onRemove: () => onRemove(items[index]),
        ),
        childCount: items.length,
      ),
    );
  }
}
