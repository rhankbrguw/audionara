import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_state.dart';

import '../widgets/player_shimmer.dart';
import '../widgets/player_error.dart';
import '../widgets/player_layouts.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PlayerBloc, PlayerState>(
      listener: (context, state) {
        if (state is PlayerError) {
          AppSnackbar.show(
            context,
            '${PlayerStrings.playbackError}${state.message}',
            isError: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          title: const Text(PlayerStrings.nowPlaying),
          centerTitle: true,
        ),
        body: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
            if (state is PlayerLoading || state is PlayerInitial) {
              return const PlayerShimmer();
            }

            if (state is PlayerPlaying) {
              return _buildPlayerUI(context, state);
            }

            if (state is PlayerError) {
              return const PlayerErrorView();
            }

            return const Center(child: Text(GeneralStrings.initializing));
          },
        ),
      ),
    );
  }

  Widget _buildPlayerUI(BuildContext context, PlayerPlaying state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return PlayerDesktopLayout(state: state);
        }
        return PlayerMobileLayout(state: state, constraints: constraints);
      },
    );
  }
}
