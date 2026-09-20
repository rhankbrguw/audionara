import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_strings.dart';
import '../../../player/domain/entities/artist_detail.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../../../player/domain/repositories/track_repository.dart';
import '../widgets/mini_player.dart';
import '../widgets/artist_detail_error.dart';
import '../widgets/artist_detail_content.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class ArtistDetailPage extends StatefulWidget {
  final String artistId;
  final String artistName;
  final String genre;

  const ArtistDetailPage({
    super.key,
    required this.artistId,
    required this.artistName,
    required this.genre,
  });

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  late Future<ArtistDetail> _artistFuture;

  @override
  void initState() {
    super.initState();
    _loadArtist();
  }

  void _loadArtist() {
    final repo = context.read<PlayerBloc>().searchByVibeUseCase.repository;
    if (widget.artistId.isNotEmpty && widget.artistId != 'unknown') {
      _artistFuture = repo.getArtistDetail(widget.artistId);
    } else {
      _artistFuture = _fetchArtistBySearch(repo);
    }
  }

  Future<ArtistDetail> _fetchArtistBySearch(TrackRepository repo) async {
    final multi = await repo.searchMulti(widget.artistName);
    if (multi.artists.isNotEmpty) {
      final target = widget.artistName.toLowerCase().trim();
      final match = multi.artists.firstWhere(
        (t) => t.artist.toLowerCase().trim() == target || t.title.toLowerCase().trim() == target,
        orElse: () => multi.artists.first,
      );
      return repo.getArtistDetail(match.id);
    }
    final tracks = await repo.searchRaw(widget.artistName);
    return ArtistDetail(
      id: widget.artistId,
      name: widget.artistName,
      picture: tracks.isNotEmpty ? tracks.first.coverArt : '',
      bio: '',
      history: '',
      fansCount: 0,
      albumCount: 0,
      genres: widget.genre.isNotEmpty ? [widget.genre] : [],
      topTracks: tracks,
      albums: [],
    );
  }

  void _playTrack(Track track, List<Track> queue) {
    context.read<PlayerBloc>().add(PlayTrackEvent(track, queue));
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
              child: FutureBuilder<ArtistDetail>(
                future: _artistFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildPlaceholderScaffold(
                      const CircularProgressIndicator(color: AppColors.primary),
                    );
                  }
                  if (snapshot.hasError) {
                    return _buildPlaceholderScaffold(
                      ArtistDetailError(
                        error: snapshot.error.toString(),
                        onRetry: () => setState(_loadArtist),
                      ),
                    );
                  }
                  final artist = snapshot.data;
                  if (artist == null) {
                    return _buildPlaceholderScaffold(
                      const Text(
                        GeneralStrings.noArtistTracksFound,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return ArtistDetailContent(
                    artist: artist,
                    onPlayTrack: _playTrack,
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

  Widget _buildPlaceholderScaffold(Widget child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Center(child: child),
    );
  }
}
