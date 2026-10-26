import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/auth_client.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';

import 'features/user/data/repositories/user_repository.dart';
import 'features/user/presentation/bloc/user_bloc.dart';
import 'features/user/presentation/bloc/user_event.dart';

import 'features/player/presentation/bloc/player_bloc.dart';
import 'features/player/domain/usecases/search_by_vibe_usecase.dart';
import 'features/player/domain/usecases/fetch_mix_for_you_usecase.dart';
import 'features/player/domain/usecases/record_metric_usecase.dart';
import 'features/player/domain/usecases/log_history_usecase.dart';
import 'features/player/data/repositories/api_track_repository.dart';
import 'features/player/presentation/bloc/lyrics_bloc.dart';

import 'features/playlist/presentation/bloc/playlist_bloc.dart';
import 'features/playlist/presentation/bloc/playlist_event.dart';
import 'features/playlist/data/repositories/playlist_repository.dart';

import 'features/playlist/presentation/bloc/custom_playlist_bloc.dart';
import 'features/playlist/presentation/bloc/custom_playlist_event.dart';
import 'features/playlist/data/repositories/custom_playlist_repository.dart';

import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';

import 'features/home/data/repositories/home_repository.dart';

class AppBlocProviders extends StatelessWidget {
  final Widget child;
  final SharedPreferences prefs;
  final AuthRepository authRepo;
  final AuthClient authClient;
  final http.Client httpClient;

  const AppBlocProviders({
    super.key,
    required this.child,
    required this.prefs,
    required this.authRepo,
    required this.authClient,
    required this.httpClient,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HomeRepository(authClient),
      child: MultiBlocProvider(
        providers: [
        BlocProvider(
          create: (context) => AuthBloc(repository: authRepo)..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(prefs: prefs)..add(LoadSettings()),
        ),
        BlocProvider(
          create: (context) => UserBloc(
            repository: UserRepository(client: authClient, prefs: prefs),
          )..add(const LoadUser()),
        ),
        BlocProvider(
          create: (context) {
            final trackRepo = ApiTrackRepository(client: authClient, prefs: prefs);
            return PlayerBloc(
              searchByVibeUseCase: SearchByVibeUseCase(repository: trackRepo),
              fetchMixForYouUseCase: FetchMixForYouUseCase(repository: trackRepo),
              recordMetricUseCase: RecordMetricUseCase(trackRepo),
              logHistoryUseCase: LogHistoryUseCase(trackRepo),
            );
          },
        ),
        BlocProvider(
          create: (context) => PlaylistBloc(repository: PlaylistRepository(client: authClient)),
        ),
        BlocProvider(
          create: (context) => CustomPlaylistBloc(
            repository: CustomPlaylistRepository(client: authClient, prefs: prefs),
          )..add(FetchCustomPlaylistsRequested()),
        ),
        BlocProvider(create: (context) => LyricsBloc(client: httpClient)),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.read<CustomPlaylistBloc>().add(FetchCustomPlaylistsRequested());
            context.read<PlaylistBloc>().add(LoadFavourites());
            context.read<UserBloc>().add(const LoadUser());
          }
        },
        child: child,
      ),
    ));
  }
}
