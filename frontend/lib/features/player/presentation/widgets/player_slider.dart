import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import 'custom_track_shape.dart';

class PlayerSlider extends StatefulWidget {
  const PlayerSlider({super.key, required this.state});

  final PlayerPlaying state;

  @override
  State<PlayerSlider> createState() => _PlayerSliderState();
}

class _PlayerSliderState extends State<PlayerSlider> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final totalMs = widget.state.duration.inMilliseconds > 0
        ? widget.state.duration.inMilliseconds
        : (widget.state.track.durationMs > 0 ? widget.state.track.durationMs : 1);
    final max = totalMs.toDouble();

    final currentVal = _dragValue ?? widget.state.position.inMilliseconds.toDouble();
    final clampedValue = currentVal.clamp(0.0, max);

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.surfaceVariant,
        thumbColor: AppColors.onBackground,
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 6.0,
          elevation: 0,
        ),
        trackShape: const CustomTrackShape(),
      ),
      child: Slider(
        min: 0.0,
        max: max,
        value: clampedValue,
        onChangeStart: (value) {
          setState(() => _dragValue = value);
        },
        onChanged: (value) {
          setState(() => _dragValue = value);
        },
        onChangeEnd: (value) {
          final target = Duration(milliseconds: value.toInt());
          context.read<PlayerBloc>().add(PlayerSeeked(position: target));
          setState(() => _dragValue = null);
        },
      ),
    );
  }
}
