import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/login_prompt.dart';
import '../../../../core/widgets/error_snackbar.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_state.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/repositories/home_repository.dart';
import '../widgets/home_feed_sections.dart';
import '../widgets/mini_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<HomeFeed> _homeFeedFuture;

  @override
  void initState() {
    super.initState();
    _homeFeedFuture = context.read<HomeRepository>().getHomeFeed();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _homeFeedFuture = context.read<HomeRepository>().getHomeFeed(forceRefresh: true);
    });
    await _homeFeedFuture;
  }

  void _handleProfileTap() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.push('/settings');
    } else {
      showLoginPrompt(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: MultiBlocListener(
          listeners: [
            BlocListener<PlayerBloc, PlayerState>(
              listener: (context, state) {
                if (state is PlayerError) {
                  ErrorSnackbar.show(context, state.message, isError: true);
                }
              },
            ),
          ],
          child: ResponsiveWrapper(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FutureBuilder<HomeFeed>(
                    future: _homeFeedFuture,
                    builder: (context, snapshot) {
                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        child: HomeFeedSections(
                          feed: snapshot.data,
                          onProfileTap: _handleProfileTap,
                        ),
                      );
                    },
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MiniPlayer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
