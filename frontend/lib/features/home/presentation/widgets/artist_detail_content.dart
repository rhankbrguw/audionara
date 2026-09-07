import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/interactive_pressable.dart';
import '../../../player/domain/entities/artist_detail.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';
import 'artist_hero_header.dart';
import 'artist_bio_section.dart';
import 'artist_discography_section.dart';
import 'artist_top_tracks_section.dart';

class ArtistDetailContent extends StatelessWidget {
  final ArtistDetail artist;
  final void Function(Track, List<Track>) onPlayTrack;

  const ArtistDetailContent({
    super.key,
    required this.artist,
    required this.onPlayTrack,
  });

  @override
  Widget build(BuildContext context) {
    final playableTracks = artist.topTracks.where((t) => t.streamUrl.isNotEmpty).toList();

    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        final isPlaying = state is PlayerPlaying;
        final bottomInset = MediaQuery.of(context).padding.bottom;
        final compactBottom = (bottomInset * 0.35).clamp(0.0, 8.0);
        final bottomPadding = isPlaying ? (54.0 + compactBottom) : (AppSpacing.md + bottomInset);

        return CustomScrollView(
          slivers: [
            ArtistHeroHeader(artist: artist),
            ArtistBioSection(bio: artist.bio, history: artist.history),
            ArtistDiscographySection(
              artistName: artist.name,
              albums: artist.albums,
            ),
            _buildTopTracksHeader(context, playableTracks),
            ArtistTopTracksSection(
              tracks: artist.topTracks,
              onPlayTrack: onPlayTrack,
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: bottomPadding)),
          ],
        );
      },
    );
  }

  Widget _buildTopTracksHeader(BuildContext context, List<Track> playableTracks) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ArtistStrings.topTracks,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (playableTracks.isNotEmpty)
              InteractivePressable(
                onTap: () => onPlayTrack(playableTracks.first, playableTracks),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowMedium,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.onPrimary,
                    size: 26,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
