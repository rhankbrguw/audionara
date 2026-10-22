import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/general_strings.dart';
import '../../../../../core/theme/app_colors.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';

class PlayerErrorView extends StatelessWidget {
  const PlayerErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            GeneralStrings.failedToLoadTrack,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PlayerBloc>().add(
                const PlayerVibeRequested(vibe: 'synthwave'),
              );
            },
            label: const Text(GeneralStrings.retry),
          ),
        ],
      ),
    );
  }
}
