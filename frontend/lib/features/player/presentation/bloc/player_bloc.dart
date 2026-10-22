import 'dart:async';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/audio_service.dart';
import '../../domain/entities/track.dart';
import '../../domain/usecases/search_by_vibe_usecase.dart';
import '../../domain/usecases/fetch_mix_for_you_usecase.dart';
import '../../domain/usecases/record_metric_usecase.dart';
import '../../domain/usecases/log_history_usecase.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/vibe_type.dart';
import 'player_event.dart';
import 'player_state.dart';
import '../../data/services/recently_played_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

part 'player_bloc_handlers.dart';
part 'player_bloc_handlers_events.dart';
part 'player_bloc_handlers_queue.dart';
part 'player_bloc_playback_skip.dart';
part 'player_bloc_timer_events.dart';
part 'player_bloc_playback.dart';
part 'player_bloc_playback_internal.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc({
    required this.searchByVibeUseCase,
    required this.fetchMixForYouUseCase,
    required this.recordMetricUseCase,
    required this.logHistoryUseCase,
    AudioService? audioService,
    RecentlyPlayedService? recentlyPlayedService,
  }) : audioService = audioService ?? AudioService(),
       recentlyPlayedService = recentlyPlayedService ?? RecentlyPlayedService(),
       super(const PlayerInitial()) {
    on<PlayerVibeRequested>((e, emit) => _onVibeRequested(e, emit));
    on<PlayerMixForYouRequested>((e, emit) => _onMixForYouRequested(e, emit));
    on<PlayerPaused>((e, emit) => onPaused(e, emit));
    on<PlayerResumed>((e, emit) => onResumed(e, emit));
    on<PlayerSeeked>((e, emit) => onSeeked(e, emit));
    on<PlayerPositionUpdated>((e, emit) => onPositionUpdated(e, emit));
    on<PlayerDurationUpdated>((e, emit) => onDurationUpdated(e, emit));
    on<PlayerStateChanged>((e, emit) => onPlayerStateChanged(e, emit));
    on<PlayerToggleShuffle>((e, emit) => onToggleShuffle(e, emit));
    on<PlayerToggleRepeat>((e, emit) => onToggleRepeat(e, emit));
    on<PlayerNextRequested>((e, emit) => _onNextRequested(e, emit));
    on<PlayerPreviousRequested>((e, emit) => _onPreviousRequested(e, emit));
    on<PlayTrackEvent>((e, emit) => _onPlayTrackEvent(e, emit));
    on<PlayerFetchMoreRequested>((e, emit) => onFetchMoreRequested(e, emit));
    on<PlayerSleepTimerSet>((e, emit) => onSleepTimerSet(e, emit));
    on<PlayerSleepTimerTicked>((e, emit) => onSleepTimerTicked(e, emit));
    on<PlayerSleepTimerCancelled>((e, emit) => onSleepTimerCancelled(e, emit));
    on<PlayerQueueUpdated>((e, emit) => onQueueUpdated(e, emit));
    on<PlayerAddToQueue>((e, emit) => onAddToQueue(e, emit));
    on<PlayerRemoveFromQueue>((e, emit) => onRemoveFromQueue(e, emit));
    on<PlayerReorderQueue>((e, emit) => onReorderQueue(e, emit));

    int lastPosTime = 0;
    _positionSubscription = this.audioService.positionStream.listen(
      (pos) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastPosTime > positionDebounceMs) {
          lastPosTime = now;
          add(PlayerPositionUpdated(position: pos));
        }
      },
    );
    _durationSubscription = this.audioService.durationStream.listen(
      (dur) => add(PlayerDurationUpdated(duration: dur)),
    );
    _playerStateSubscription = this.audioService.playerStateStream.listen(
      (s) => add(PlayerStateChanged(state: s)),
    );
  }

  final SearchByVibeUseCase searchByVibeUseCase;
  final FetchMixForYouUseCase fetchMixForYouUseCase;
  final RecordMetricUseCase recordMetricUseCase;
  final LogHistoryUseCase logHistoryUseCase;
  final AudioService audioService;
  final RecentlyPlayedService recentlyPlayedService;

  late final StreamSubscription _positionSubscription;
  late final StreamSubscription _durationSubscription;
  late final StreamSubscription _playerStateSubscription;

  bool isShuffleEnabled = false;
  bool isRepeatEnabled = false;

  Timer? _sleepTimer;
  int? _sleepTimerRemaining;

  int _lastSeekTimeMs = 0;
  int _playbackToken = 0;
  int _lastTrackSwitchMs = 0;

  static const positionDebounceMs = 200;

  @override
  Future<void> close() async {
    await Future.wait([
      _positionSubscription.cancel(),
      _durationSubscription.cancel(),
      _playerStateSubscription.cancel(),
    ]);
    _sleepTimer?.cancel();
    await audioService.stop();
    return super.close();
  }
}
