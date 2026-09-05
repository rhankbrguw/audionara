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

  void _scrollToLine(int index) {
    if (index >= 0 && _itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      listener: (context, playerState) {
        if (playerState is PlayerPlaying) {
          final pos = playerState.position;
          int newIndex = -1;
          for (int i = 0; i < widget.syncedLyrics.length; i++) {
            if (pos >= widget.syncedLyrics[i].time) {
              newIndex = i;
            } else {
              break;
            }
          }
          if (newIndex != _currentLineIndex) {
            _currentLineIndex = newIndex;
            _scrollToLine(_currentLineIndex);
          }
        }
      },
      builder: (context, playerState) {
        int activeIndex = _currentLineIndex;
        if (playerState is PlayerPlaying) {
          final pos = playerState.position;
          for (int i = 0; i < widget.syncedLyrics.length; i++) {
            if (pos >= widget.syncedLyrics[i].time) {
              activeIndex = i;
            } else {
              break;
            }
          }
        }

        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.transparent,
                AppColors.background,
                AppColors.background,
                AppColors.transparent,
              ],
              stops: [0.0, 0.15, 0.85, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            padding: const EdgeInsets.symmetric(vertical: 64.0),
            itemCount: widget.syncedLyrics.length,
            itemBuilder: (context, index) {
              final line = widget.syncedLyrics[index];
              final isActive = index == activeIndex;
              final isPast = index < activeIndex;

              return LyricsLineWidget(
                line: line,
                isActive: isActive,
                isPast: isPast,
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
