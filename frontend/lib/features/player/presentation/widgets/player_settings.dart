import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/player_strings.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../../../../core/widgets/login_prompt.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'player_add_to_playlist_dialog.dart';

void showSettingsBottomSheet(BuildContext context, dynamic track) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.playlist_add,
                color: AppColors.textPrimary,
              ),
              title: Text(
                PlayerStrings.addToPlaylist,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  showAddToPlaylistDialog(context, track);
                } else {
                  showLoginPrompt(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.textPrimary),
              title: Text(
                PlayerStrings.viewArtist,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                final String routeId = track.artistId.isNotEmpty
                    ? track.artistId
                    : 'unknown';
                context.push(
                  '/artist/$routeId',
                  extra: ArtistRouteExtra(
                    id: track.artistId,
                    name: track.artist,
                    genre: '',
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.high_quality,
                color: AppColors.textPrimary,
              ),
              title: Text(
                PlayerStrings.audioQuality,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  context.push('/settings');
                } else {
                  showLoginPrompt(context);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
