part of 'player_bloc.dart';

extension PlayerBlocHandlersQueue on PlayerBloc {
  void onQueueUpdated(
    PlayerQueueUpdated event,
    Emitter<PlayerState> emit,
  ) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;

    final newQueue = List<Track>.from(event.queue);
    emit(
      withMeta(
        current,
        queue: newQueue,
        originalQueue: List<Track>.from(newQueue),
      ),
    );
  }

  void onToggleShuffle(PlayerToggleShuffle event, Emitter<PlayerState> emit) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    isShuffleEnabled = !isShuffleEnabled;

    List<Track> newQueue;
    int newIndex;

    if (isShuffleEnabled) {
      final currentTrack = current.queue[current.currentIndex];
      final remaining = current.queue.where((t) => t.id != currentTrack.id).toList();
      final balanced = _fairShuffle(remaining);
      newQueue = [currentTrack, ...balanced];
      newIndex = 0;
    } else {
      newQueue = List<Track>.from(current.originalQueue);
      final currentTrack = current.queue[current.currentIndex];
      newIndex = newQueue.indexWhere((t) => t.id == currentTrack.id);
      if (newIndex == -1) newIndex = 0;
    }

    emit(withMeta(current, queue: newQueue, currentIndex: newIndex));
  }

  List<Track> _fairShuffle(List<Track> tracks) {
    if (tracks.length <= 2) {
      return List<Track>.from(tracks)..shuffle();
    }
    final Map<String, List<Track>> artistGroups = {};
    for (final track in tracks) {
      final key = track.artist.trim().toLowerCase();
      artistGroups.putIfAbsent(key, () => []).add(track);
    }
    if (artistGroups.keys.length <= 1) {
      return List<Track>.from(tracks)..shuffle();
    }
    for (final group in artistGroups.values) {
      group.shuffle();
    }
    final sortedKeys = artistGroups.keys.toList()
      ..sort((a, b) => artistGroups[b]!.length.compareTo(artistGroups[a]!.length));

    final List<Track> result = [];
    String lastArtist = '';

    while (artistGroups.values.any((list) => list.isNotEmpty)) {
      String? nextKey;
      for (final key in sortedKeys) {
        if (artistGroups[key]!.isNotEmpty && key != lastArtist) {
          nextKey = key;
          break;
        }
      }
      nextKey ??= sortedKeys.firstWhere((k) => artistGroups[k]!.isNotEmpty);
      result.add(artistGroups[nextKey]!.removeAt(0));
      lastArtist = nextKey;
      sortedKeys.sort((a, b) => artistGroups[b]!.length.compareTo(artistGroups[a]!.length));
    }
    return result;
  }

  void onToggleRepeat(PlayerToggleRepeat event, Emitter<PlayerState> emit) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    isRepeatEnabled = !isRepeatEnabled;
    emit(withMeta(current));
  }

  void onAddToQueue(PlayerAddToQueue event, Emitter<PlayerState> emit) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    final newQueue = List<Track>.from(current.queue);
    final newOriginal = List<Track>.from(current.originalQueue);

    if (event.playNext) {
      final insertIdx = current.currentIndex + 1;
      if (insertIdx <= newQueue.length) {
        newQueue.insert(insertIdx, event.track);
      } else {
        newQueue.add(event.track);
      }
    } else {
      newQueue.add(event.track);
    }
    newOriginal.add(event.track);
    emit(withMeta(current, queue: newQueue, originalQueue: newOriginal));
  }

  void onRemoveFromQueue(PlayerRemoveFromQueue event, Emitter<PlayerState> emit) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    if (event.index < 0 || event.index >= current.queue.length || event.index == current.currentIndex) return;

    final newQueue = List<Track>.from(current.queue);
    final removed = newQueue.removeAt(event.index);
    final newOriginal = List<Track>.from(current.originalQueue)..remove(removed);
    final newIndex = event.index < current.currentIndex ? current.currentIndex - 1 : current.currentIndex;

    emit(withMeta(current, queue: newQueue, originalQueue: newOriginal, currentIndex: newIndex));
  }

  void onReorderQueue(PlayerReorderQueue event, Emitter<PlayerState> emit) {
    if (state is! PlayerPlaying) return;
    final current = state as PlayerPlaying;
    if (event.oldIndex < 0 || event.oldIndex >= current.queue.length) return;
    if (event.newIndex < 0 || event.newIndex > current.queue.length) return;

    final newQueue = List<Track>.from(current.queue);
    final target = event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
    final item = newQueue.removeAt(event.oldIndex);
    newQueue.insert(target, item);

    final currentTrack = current.queue[current.currentIndex];
    final updatedIndex = newQueue.indexWhere((t) => t.id == currentTrack.id);

    emit(withMeta(current, queue: newQueue, currentIndex: updatedIndex >= 0 ? updatedIndex : current.currentIndex));
  }
}

