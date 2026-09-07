import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import 'player_secondary_controls.dart';

class PlayerControls extends StatelessWidget {
  final PlayerPlaying state;
  final VoidCallback onSettingsTap;

  const PlayerControls({
    super.key,
    required this.state,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 42,
              icon: const Icon(
                Icons.skip_previous,
                color: AppColors.onBackground,
              ),
              onPressed: () => context.read<PlayerBloc>().add(
                const PlayerPreviousRequested(),
              ),
            ),
            const SizedBox(width: 24),
            IconButton(
              iconSize: 72,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  state.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  key: ValueKey(state.isPlaying),
                  color: AppColors.onBackground,
                ),
              ),
              onPressed: () {
                if (state.isPlaying) {
                  context.read<PlayerBloc>().add(const PlayerPaused());
                } else {
                  context.read<PlayerBloc>().add(const PlayerResumed());
                }
              },
            ),
            const SizedBox(width: 24),
            IconButton(
              iconSize: 42,
              icon: const Icon(Icons.skip_next, color: AppColors.onBackground),
              onPressed: () =>
                  context.read<PlayerBloc>().add(const PlayerNextRequested()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        PlayerSecondaryControls(
          state: state,
          onSettingsTap: onSettingsTap,
        ),
      ],
    );
  }
}
