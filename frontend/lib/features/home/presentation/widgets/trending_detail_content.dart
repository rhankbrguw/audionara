import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/bouncing_widget.dart';
import '../../../player/domain/entities/track.dart';
import 'trending_detail_header.dart';
import 'trending_track_tile.dart';

class TrendingDetailContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final Color color1;
  final Color color2;
  final String cover;
  final List<Track> tracks;
  final void Function(Track, List<Track>) onPlayTrack;
  final void Function(List<Track>) onPlayAll;

  const TrendingDetailContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color1,
    required this.color2,
    this.cover = '',
    required this.tracks,
    required this.onPlayTrack,
    required this.onPlayAll,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        TrendingDetailHeader(
          title: title,
          subtitle: subtitle,
          badge: badge,
          color1: color1,
          color2: color2,
          cover: cover,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${tracks.length} tracks',
                    style: TextStyle(
                      color: AppColors.textInverse.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                BouncingWidget(
                  onTap: () => onPlayAll(tracks),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.textPrimary,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final track = tracks[index];
              return TrendingTrackTile(
                track: track,
                onTap: () => onPlayTrack(track, tracks),
              );
            },
            childCount: tracks.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}
