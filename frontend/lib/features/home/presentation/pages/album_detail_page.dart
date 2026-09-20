import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../player/domain/entities/album_detail.dart';
import '../../../player/domain/entities/track.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../widgets/mini_player.dart';
import '../widgets/album_detail_scaffolds.dart';
import '../widgets/album_detail_content.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class AlbumDetailPage extends StatefulWidget {
  final String albumId;
  final String? initialCoverArt;
  final String? initialTitle;
  final String? initialArtist;

  const AlbumDetailPage({
    super.key,
    required this.albumId,
    this.initialCoverArt,
    this.initialTitle,
    this.initialArtist,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  late Future<AlbumDetail> _albumFuture;

  @override
  void initState() {
    super.initState();
    final repo = context.read<PlayerBloc>().searchByVibeUseCase.repository;
    if (widget.albumId.isNotEmpty && widget.albumId != 'unknown') {
      _albumFuture = repo.getAlbumDetail(widget.albumId);
    } else {
      _albumFuture = _fetchAlbumBySearch(repo);
    }
  }

  Future<AlbumDetail> _fetchAlbumBySearch(dynamic repo) async {
    final query = '${widget.initialTitle ?? ''} ${widget.initialArtist ?? ''}'
        .trim();
    if (query.isEmpty) throw const NotFoundException(message: GeneralStrings.couldNotLoadAlbum);

    final multiSearch = await repo.searchMulti(query);
    if (multiSearch.albums.isNotEmpty) {
      return repo.getAlbumDetail(multiSearch.albums.first.id);
    }
    throw const NotFoundException(message: GeneralStrings.couldNotLoadAlbum);
  }

  String _formatDuration(int ms) {
    final total = Duration(milliseconds: ms);
    final hours = total.inHours;
    final minutes = total.inMinutes.remainder(60);
    final seconds = total.inSeconds.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  String _formatTrackDuration(int ms) {
    if (ms == 0) return '';
    final total = Duration(milliseconds: ms);
    final minutes = total.inMinutes;
    final seconds = total.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
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
              child: FutureBuilder<AlbumDetail>(
                future: _albumFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AlbumScaffolds.buildLoadingScaffold(
                      context,
                      widget.initialCoverArt,
                    );
                  }
                  if (snapshot.hasError) {
                    return AlbumScaffolds.buildErrorScaffold(
                      context,
                      snapshot.error.toString(),
                      widget.initialCoverArt,
                      () {
                        final repo = context
                            .read<PlayerBloc>()
                            .searchByVibeUseCase
                            .repository;
                        setState(() {
                          if (widget.albumId.isNotEmpty &&
                              widget.albumId != 'unknown') {
                            _albumFuture = repo.getAlbumDetail(widget.albumId);
                          } else {
                            _albumFuture = _fetchAlbumBySearch(repo);
                          }
                        });
                      },
                    );
                  }
                  return AlbumDetailContent(
                    album: snapshot.data!,
                    onPlayTrack: _playTrack,
                    formatDuration: _formatDuration,
                    formatTrackDuration: _formatTrackDuration,
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
}
