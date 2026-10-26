import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/clickable_artist_list.dart';
import 'scrolling_track_title.dart';
import 'player_action_buttons.dart';

class PlayerHeaderInfo extends StatelessWidget {
  const PlayerHeaderInfo({super.key, required this.track});

  final dynamic track;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  final routeId = track.albumId.isNotEmpty
                      ? track.albumId
                      : 'unknown';
                  context.push(
                    '/album/$routeId',
                    extra: AlbumRouteExtra(
                      id: track.albumId,
                      coverArt: track.coverArt,
                      title: track.title,
                      artist: track.artist,
                    ),
                  );
                },
                child: ScrollingTrackTitle(title: track.title),
              ),
              const SizedBox(height: 3),
              ClickableArtistList(
                artistString: track.artist,
                trackTitle: track.title,
                artistId: track.artistId,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        PlayerActionButtons(track: track),
      ],
    );
  }
}
