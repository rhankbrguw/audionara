import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/player_strings.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/error_snackbar.dart';
import '../../../../../core/widgets/login_prompt.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/track.dart';
import '../bloc/player_bloc.dart';
import '../bloc/player_event.dart';
import '../bloc/player_state.dart';
import 'player_add_to_playlist_dialog.dart';

void showSettingsBottomSheet(BuildContext context, Track track) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => PlayerSettingsSheetContent(track: track),
  );
}

class PlayerSettingsSheetContent extends StatelessWidget {
  final Track track;
  const PlayerSettingsSheetContent({super.key, required this.track});

  void _onPlayNext(BuildContext context) {
    Navigator.pop(context);
    context.read<PlayerBloc>().add(PlayerAddToQueue(track, playNext: true));
    AppSnackbar.show(context, PlayerStrings.queueNextAdded);
  }

  void _onAddToQueue(BuildContext context) {
    Navigator.pop(context);
    context.read<PlayerBloc>().add(PlayerAddToQueue(track, playNext: false));
    AppSnackbar.show(context, PlayerStrings.queueAdded);
  }

  void _onAddToPlaylist(BuildContext context) {
    Navigator.pop(context);
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      showAddToPlaylistDialog(context, track);
    } else {
      showLoginPrompt(context);
    }
  }

  void _onViewArtist(BuildContext context) {
    Navigator.pop(context);
    final String routeId =
        track.artistId.isNotEmpty ? track.artistId : 'unknown';
    context.push(
      '/artist/$routeId',
      extra: ArtistRouteExtra(id: track.artistId, name: track.artist, genre: ''),
    );
  }

  void _onAudioQuality(BuildContext context) {
    Navigator.pop(context);
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.push('/settings');
    } else {
      showLoginPrompt(context);
    }
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback? onTap,
    Color? iconColor,
  }) {
    final isEnabled = onTap != null;
    final color = isEnabled ? AppColors.textPrimary : AppColors.textSecondary.withValues(alpha: 0.4);
    return Material(
      color: AppColors.transparent,
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        enabled: isEnabled,
        leading: Icon(icon, color: iconColor ?? color, size: 22),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)) : null,
        onTap: onTap,
      ),
    );
  }

  List<Widget> _buildTiles(BuildContext context) {
    final state = context.read<PlayerBloc>().state;
    final isPlaying = state is PlayerPlaying;
    final nextIdx = isPlaying ? state.currentIndex + 1 : 0;
    final isNext = isPlaying && nextIdx < state.queue.length && state.queue[nextIdx].id == track.id;
    final isQueued = isPlaying && state.queue.skip(nextIdx).any((t) => t.id == track.id);

    return [
      _buildTile(context, icon: isNext ? Icons.check_circle_outline_rounded : Icons.playlist_play_rounded, title: PlayerStrings.queuePlayNext, subtitle: isNext ? PlayerStrings.alreadyPlayingNext : null, iconColor: isNext ? AppColors.primary : null, onTap: isNext ? null : () => _onPlayNext(context)),
      _buildTile(context, icon: isQueued ? Icons.check_circle_outline_rounded : Icons.queue_music_rounded, title: PlayerStrings.queueAddToQueue, subtitle: isQueued ? PlayerStrings.alreadyInQueue : null, onTap: isQueued ? null : () => _onAddToQueue(context)),
      _buildTile(context, icon: Icons.playlist_add_rounded, title: PlayerStrings.addToPlaylist, onTap: () => _onAddToPlaylist(context)),
      _buildTile(context, icon: Icons.person_outline_rounded, title: PlayerStrings.viewArtist, onTap: () => _onViewArtist(context)),
      _buildTile(context, icon: Icons.high_quality_rounded, title: PlayerStrings.audioQuality, onTap: () => _onAudioQuality(context)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const _DragHandle(),
          const SizedBox(height: 8),
          ..._buildTiles(context),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
