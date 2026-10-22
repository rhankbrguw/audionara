import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/lyrics_state.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import 'lyrics_line_widget.dart';

class SyncedLyricsView extends StatefulWidget {
  const SyncedLyricsView({
    super.key,
    required this.syncedLyrics,
  });

  final List<LyricLine> syncedLyrics;

  @override
  State<SyncedLyricsView> createState() => _SyncedLyricsViewState();
}

class _SyncedLyricsViewState extends State<SyncedLyricsView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  int _currentLineIndex = -1;

  @override
  void initState() {
    super.initState();
    final playerState = context.read<PlayerBloc>().state;
    if (playerState is PlayerPlaying) {
      _currentLineIndex = _findActiveLineIndex(playerState.position);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _currentLineIndex >= 0) {
          _scrollToLine(_currentLineIndex);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant SyncedLyricsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.syncedLyrics != widget.syncedLyrics) {
      final playerState = context.read<PlayerBloc>().state;
      if (playerState is PlayerPlaying) {
        _currentLineIndex = _findActiveLineIndex(playerState.position);
        _scrollToLine(_currentLineIndex);
      }
    }
  }

  int _findActiveLineIndex(Duration pos) {
    final effectivePos = pos + const Duration(milliseconds: 150);
    int active = -1;
    for (int i = 0; i < widget.syncedLyrics.length; i++) {
      if (effectivePos >= widget.syncedLyrics[i].time) {
        active = i;
      } else {
        break;
      }
    }
    return active;
  }

  void _scrollToLine(int index) {
    if (index < 0) return;
    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.45,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      listener: (context, playerState) {
        if (playerState is PlayerPlaying) {
          final newIndex = _findActiveLineIndex(playerState.position);
          if (newIndex != _currentLineIndex) {
            _currentLineIndex = newIndex;
            _scrollToLine(_currentLineIndex);
          }
        }
      },
      builder: (context, playerState) {
        final activeIndex = playerState is PlayerPlaying
            ? _findActiveLineIndex(playerState.position)
            : _currentLineIndex;

        return ShaderMask(
          shaderCallback: (r) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.transparent, AppColors.background, AppColors.background, AppColors.transparent],
            stops: [0.0, 0.15, 0.85, 1.0],
          ).createShader(r),
          blendMode: BlendMode.dstIn,
          child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            initialScrollIndex: _currentLineIndex >= 0 ? _currentLineIndex : 0,
            initialAlignment: _currentLineIndex >= 0 ? 0.45 : 0.0,
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            itemCount: widget.syncedLyrics.length,
            itemBuilder: (context, index) {
              final line = widget.syncedLyrics[index];
              return LyricsLineWidget(
                line: line,
                isActive: index == activeIndex,
                isPast: index < activeIndex,
                onTap: () {
                  _currentLineIndex = index;
                  _scrollToLine(index);
                  context.read<PlayerBloc>().add(
                    PlayerSeeked(position: line.time),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
