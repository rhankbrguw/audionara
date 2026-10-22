import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/home_strings.dart';
import '../../../../core/navigation/route_extras.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/interactive_pressable.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../../../player/presentation/bloc/player_event.dart';
import '../../../player/presentation/bloc/player_state.dart';

class MixForYouBanner extends StatelessWidget {
  const MixForYouBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InteractivePressable(
      onTap: () {
        context.push(
          '/trending/MixForYou',
          extra: TrendingRouteExtra(
            title: HomeStrings.mixForYouTitle,
            subtitle: HomeStrings.mixForYouSubtitle,
            badge: 'DAILY MIX',
            color1: AppColors.primary.toARGB32(),
            color2: AppColors.secondary.toARGB32(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HomeStrings.mixForYouTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    HomeStrings.mixForYouSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textInverse.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            BlocBuilder<PlayerBloc, PlayerState>(
              builder: (context, state) {
                final isMixLoading = state is PlayerLoading;
                if (isMixLoading) {
                  return const CircularProgressIndicator(
                    color: AppColors.textInverse,
                  );
                }
                return GestureDetector(
                  onTap: () {
                    context.read<PlayerBloc>().add(const PlayerMixForYouRequested());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.glassOverlay,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.textInverse,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
