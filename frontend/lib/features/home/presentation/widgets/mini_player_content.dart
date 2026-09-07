import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/lazy_image.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';
import '../../../player/presentation/bloc/player_event.dart';

class MiniPlayerContent extends StatelessWidget {
  final PlayerPlaying state;

  const MiniPlayerContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final track = state.track;
    final posMs = state.position.inMilliseconds;
    final durMs = state.duration.inMilliseconds > 0 ? state.duration.inMilliseconds : 1;
    final progress = (posMs / durMs).clamp(0.0, 1.0);
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final compactBottom = (bottomInset * 0.35).clamp(0.0, 8.0);

    return RepaintBoundary(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          border: Border(top: BorderSide(color: AppColors.borderSubtle, width: 1.0)),
          boxShadow: [BoxShadow(color: AppColors.shadowMedium, blurRadius: 8, offset: Offset(0, -2))],
        ),
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.only(bottom: compactBottom),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => context.push('/player'),
            child: SizedBox(
              height: 54,
              child: Stack(
                children: [
                  _buildProgressBar(progress),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.sm + 4, 3, AppSpacing.sm + 4, 1),
                    child: Row(
                      children: [
                        _buildArtwork(track.coverArt, track.id),
                        const SizedBox(width: AppSpacing.sm + 2),
                        _buildTrackInfo(context, track.title, track.artist),
                        _buildControls(context, state.isPlaying),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 2,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: AppColors.transparent,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
      ),
    );
  }

  Widget _buildArtwork(String coverArt, String trackId) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: AppColors.surface),
      clipBehavior: Clip.antiAlias,
      child: coverArt.isNotEmpty
          ? Hero(tag: 'album_art_$trackId', child: LazyImage(imageUrl: coverArt, fit: BoxFit.cover))
          : const Icon(Icons.music_note, size: 18, color: AppColors.textSecondary),
    );
  }

  Widget _buildTrackInfo(BuildContext context, String title, String artist) {
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontSize: 14,
        );
    final artistStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
        );

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(artist, style: artistStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, bool isPlaying) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              key: ValueKey(isPlaying),
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () {
            final bloc = context.read<PlayerBloc>();
            isPlaying ? bloc.add(const PlayerPaused()) : bloc.add(const PlayerResumed());
          },
        ),
        IconButton(
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: const Icon(Icons.skip_next_rounded, color: AppColors.textPrimary),
          onPressed: () => context.read<PlayerBloc>().add(const PlayerNextRequested()),
        ),
      ],
    );
  }
}
