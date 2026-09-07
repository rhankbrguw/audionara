import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/artist_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../player/domain/entities/track.dart';
import 'artist_track_tile.dart';

class ArtistTopTracksSection extends StatefulWidget {
  final List<Track> tracks;
  final void Function(Track, List<Track>) onPlayTrack;

  const ArtistTopTracksSection({
    super.key,
    required this.tracks,
    required this.onPlayTrack,
  });

  @override
  State<ArtistTopTracksSection> createState() => _ArtistTopTracksSectionState();
}

class _ArtistTopTracksSectionState extends State<ArtistTopTracksSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.tracks.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Text(
            ArtistStrings.noTopSongs,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final displayCount =
        _isExpanded ? widget.tracks.length : min(5, widget.tracks.length);
    final hasMore = widget.tracks.length > 5;

    return SliverList(
      key: ValueKey('top_tracks_${_isExpanded}_$displayCount'),
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          if (i < displayCount) {
            final track = widget.tracks[i];
            return ArtistTrackTile(
              track: track,
              onTap: () => widget.onPlayTrack(track, widget.tracks),
            );
          }
          return _buildToggleTile();
        },
        childCount: displayCount + (hasMore ? 1 : 0),
      ),
    );
  }

  Widget _buildToggleTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: TextButton.icon(
        onPressed: () => setState(() => _isExpanded = !_isExpanded),
        icon: Icon(
          _isExpanded
              ? Icons.keyboard_arrow_up_rounded
              : Icons.keyboard_arrow_down_rounded,
          color: AppColors.primary,
          size: 18,
        ),
        label: Text(
          _isExpanded ? ArtistStrings.showLess : ArtistStrings.showMore,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
