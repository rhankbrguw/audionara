import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/player_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import 'player_sleep_timer_sheet.dart';
import 'queue_bottom_sheet.dart';

class PlayerSecondaryControls extends StatelessWidget {
  final PlayerPlaying state;
  final VoidCallback onSettingsTap;

  const PlayerSecondaryControls({
    super.key,
    required this.state,
    required this.onSettingsTap,
  });

  void _toggleShuffle(BuildContext context) {
    final next = !state.isShuffleEnabled;
    context.read<PlayerBloc>().add(const PlayerToggleShuffle());
    AppSnackbar.show(
      context,
      next ? PlayerStrings.shuffleEnabled : PlayerStrings.shuffleDisabled,
    );
  }

  void _toggleRepeat(BuildContext context) {
    final next = !state.isRepeatEnabled;
    context.read<PlayerBloc>().add(const PlayerToggleRepeat());
    AppSnackbar.show(
      context,
      next ? PlayerStrings.repeatEnabled : PlayerStrings.repeatDisabled,
    );
  }

  void _handleSleepTimer(BuildContext context) {
    if (state.sleepTimerRemaining != null && state.sleepTimerRemaining! > 0) {
      context.read<PlayerBloc>().add(const PlayerSleepTimerCancelled());
      AppSnackbar.show(context, PlayerStrings.timerCanceled);
    } else {
      showSleepTimerBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTimer =
        state.sleepTimerRemaining != null && state.sleepTimerRemaining! > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 28,
          icon: Icon(
            Icons.shuffle,
            color: state.isShuffleEnabled
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
          onPressed: () => _toggleShuffle(context),
        ),
        IconButton(
          tooltip: PlayerStrings.repeatEnabled,
          iconSize: 26,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.repeat,
            color: state.isRepeatEnabled
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
          onPressed: () => _toggleRepeat(context),
        ),
        IconButton(
          tooltip: PlayerStrings.queueTitle,
          iconSize: 26,
          visualDensity: VisualDensity.compact,
          icon: const Icon(
            Icons.queue_music_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: () => showQueueBottomSheet(context),
        ),
        IconButton(
          tooltip: PlayerStrings.sleepTimerTitle,
          iconSize: 26,
          visualDensity: VisualDensity.compact,
          onPressed: () => _handleSleepTimer(context),
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.av_timer,
                size: 26,
                color: hasTimer ? AppColors.primary : AppColors.textSecondary,
              ),
              if (hasTimer) ...[
                const SizedBox(width: 4),
                Text(
                  PlayerStrings.sleepTimerRemaining(state.sleepTimerRemaining!),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          tooltip: PlayerStrings.audioQuality,
          iconSize: 26,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.settings, color: AppColors.textSecondary),
          onPressed: onSettingsTap,
        ),
      ],
    );
  }
}
