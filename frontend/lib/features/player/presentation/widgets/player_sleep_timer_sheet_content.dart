import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/player_strings.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_state.dart';
import '../bloc/player_event.dart';

class SleepTimerSheetContent extends StatefulWidget {
  const SleepTimerSheetContent({super.key});

  @override
  State<SleepTimerSheetContent> createState() => _SleepTimerSheetContentState();
}

class _SleepTimerSheetContentState extends State<SleepTimerSheetContent> {
  double _sliderValue = 0;

  @override
  void initState() {
    super.initState();
    final state = context.read<PlayerBloc>().state;
    if (state is PlayerPlaying && state.sleepTimerRemaining != null) {
      _sliderValue = _getSliderFromMinutes(state.sleepTimerRemaining!);
    }
  }

  int _getMinutesFromSlider(double value) {
    switch (value.toInt()) {
      case 1:
        return 1;
      case 2:
        return 5;
      case 3:
        return 10;
      case 4:
        return 30;
      case 5:
        return 60;
      default:
        return 0;
    }
  }

  double _getSliderFromMinutes(int mins) {
    if (mins <= 1) return 1;
    if (mins <= 5) return 2;
    if (mins <= 10) return 3;
    if (mins <= 30) return 4;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            PlayerStrings.sleepTimerTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textInverse,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            PlayerStrings.sleepTimerDesc,
            style: TextStyle(
              color: AppColors.textInverse70,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _sliderValue == 0
                ? 'Off'
                : '${_getMinutesFromSlider(_sliderValue)} Minutes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _sliderValue == 0
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.glassBorder,
              thumbColor: AppColors.textPrimary,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
              trackHeight: 4.0,
            ),
            child: Slider(
              value: _sliderValue,
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              onChangeEnd: (value) {
                if (value > 0) {
                  context.read<PlayerBloc>().add(
                    PlayerSleepTimerSet(_getMinutesFromSlider(value)),
                  );
                } else {
                  context.read<PlayerBloc>().add(
                    const PlayerSleepTimerCancelled(),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
