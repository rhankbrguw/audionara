import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_strings.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../widgets/mini_player.dart';
import '../widgets/trending_detail_content.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class TrendingDetailPage extends StatefulWidget {
  final String vibeName;
  final String title;
  final String subtitle;
  final String badge;
  final Color color1;
  final Color color2;

  const TrendingDetailPage({
    super.key,
    required this.vibeName,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color1,
    required this.color2,
  });

  @override
  State<TrendingDetailPage> createState() => _TrendingDetailPageState();
}

class _TrendingDetailPageState extends State<TrendingDetailPage> {
  late Future<List<Track>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  void _fetchTracks() {
    final useCase = context.read<PlayerBloc>().searchByVibeUseCase;
    _tracksFuture = useCase.call(widget.title).then((tracks) {
      final seen = <String>{};
      return tracks.where((t) {
        final key = '${t.title.toLowerCase().trim()}:${t.artist.toLowerCase().trim()}';
        return seen.add(key);
      }).toList();
    });
  }

  void _playTrack(Track track, List<Track> queue) {
    context.read<PlayerBloc>().add(PlayTrackEvent(track, queue));
    context.push('/player');
  }

  void _playAll(List<Track> queue) {
    if (queue.isEmpty) return;
    context.read<PlayerBloc>().add(PlayerVibeRequested(vibe: widget.title));
    context.push('/player');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            Positioned.fill(
              child: FutureBuilder<List<Track>>(
                future: _tracksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingScaffold();
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildErrorScaffold(snapshot.error?.toString() ?? GeneralStrings.noTracksFound);
                  }
                  return TrendingDetailContent(
                    title: widget.title,
                    subtitle: widget.subtitle,
                    badge: widget.badge,
                    color1: widget.color1,
                    color2: widget.color2,
                    tracks: snapshot.data!,
                    onPlayTrack: _playTrack,
                    onPlayAll: _playAll,
                  );
                },
              ),
            ),
            const Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorScaffold(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(error, style: const TextStyle(color: AppColors.textInverse)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(_fetchTracks),
            child: const Text(GeneralStrings.retry),
          ),
        ],
      ),
    );
  }
}
