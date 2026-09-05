import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/search_strings.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/bouncing_widget.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../player/domain/entities/multi_search_result.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';

class SearchTopResultCard extends StatelessWidget {
  final TopResultItem item;
  final List<Track> queue;
  final ValueChanged<String>? onRecordHistory;

  const SearchTopResultCard({
    super.key,
    required this.item,
    required this.queue,
    this.onRecordHistory,
  });

  void _onTap(BuildContext context) {
    if (item.type == 'album') {
      onRecordHistory?.call(item.title);
      context.push('/album/${item.id}', extra: AlbumRouteExtra(
        id: item.id, coverArt: item.coverArt, title: item.title, artist: item.artist,
      ));
    } else if (item.type == 'artist') {
      onRecordHistory?.call(item.title);
      context.push('/artist/${item.id}', extra: ArtistRouteExtra(
        id: item.id, name: item.title, genre: '',
      ));
    } else {
      context.read<PlayerBloc>().add(PlayTrackEvent(item.toTrack(), queue));
      context.push('/player', extra: 'search_top_result');
    }
  }

  String _badgeText() {
    if (item.type == 'artist') return SearchStrings.artistBadge;
    if (item.type == 'album') return SearchStrings.albumBadge;
    return SearchStrings.songBadge;
  }

  @override
  Widget build(BuildContext context) {
    final isArtist = item.type == 'artist';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            SearchStrings.topResult,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        BouncingWidget(
          onTap: () => _onTap(context),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.glassOverlay),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(isArtist ? 100 : AppRadius.sm),
                  child: LazyImage(
                    imageUrl: item.coverArt,
                    width: 68,
                    height: 68,
                    fit: BoxFit.cover,
                    fallbackIcon: isArtist ? Icons.person : Icons.music_note,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          _badgeText(),
                          style: const TextStyle(
                            color: AppColors.primary, fontSize: 10,
                            fontWeight: FontWeight.bold, letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.play_arrow_rounded, color: AppColors.textPrimary, size: 24),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

