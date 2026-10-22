import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/playlist_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_strings.dart';
import '../../domain/entities/playlist_item.dart';
import 'playlist_event.dart';
import 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc({required this.repository}) : super(PlaylistInitial()) {
    on<LoadFavourites>(_onLoadFavourites);
    on<ToggleFavouriteStatus>(_onToggleFavourite);
    on<CheckFavouriteStatus>(_onCheckFavourite);
  }

  final PlaylistRepository repository;

  Future<void> _onLoadFavourites(
    LoadFavourites event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoading());
    try {
      final items = await repository.getAllSavedTracks();
      emit(PlaylistLoaded(favourites: items));
    } on ServerException catch (e) {
      emit(PlaylistError(message: e.message));
    } on NetworkException catch (e) {
      emit(PlaylistError(message: e.message));
    } catch (_) {
      emit(const PlaylistError(message: GeneralStrings.unexpectedError));
    }
  }

  Future<void> _onCheckFavourite(
    CheckFavouriteStatus event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      final isSaved = await repository.isTrackSaved(event.trackId);
      emit(PlaylistTrackStatus(trackId: event.trackId, isSaved: isSaved));
    } catch (_) {
      emit(PlaylistTrackStatus(trackId: event.trackId, isSaved: false));
    }
  }

  Future<void> _onToggleFavourite(
    ToggleFavouriteStatus event,
    Emitter<PlaylistState> emit,
  ) async {
    PlaylistLoaded? rollbackState;
    List<PlaylistItem>? updatedFavourites;

    if (state is PlaylistLoaded) {
      final current = state as PlaylistLoaded;
      rollbackState = current;

      final exists = current.favourites.any(
        (t) => t.trackId == event.item.trackId,
      );
      final expectedState = !exists;
      emit(
        FavouriteToggled(trackId: event.item.trackId, isSaved: expectedState),
      );
      await Future.delayed(Duration.zero);

      if (exists) {
        updatedFavourites = current.favourites
            .where((t) => t.trackId != event.item.trackId)
            .toList();
      } else {
        updatedFavourites = List<PlaylistItem>.from(current.favourites)
          ..insert(0, event.item);
      }

      emit(PlaylistLoaded(favourites: updatedFavourites));
    } else {
      // If we don't have PlaylistLoaded state, just emit the expected state optimistically
      // (We assume it's true since it's a toggle and we don't know the current list)
      emit(FavouriteToggled(trackId: event.item.trackId, isSaved: true));
    }

    try {
      final isSavedNow = await repository.toggleTrack(event.item);
      // Re-emit just to ensure backend sync is correct (though it should match)
      emit(FavouriteToggled(trackId: event.item.trackId, isSaved: isSavedNow));

      if (updatedFavourites != null) {
        await Future.delayed(Duration.zero);
        emit(PlaylistLoaded(favourites: updatedFavourites));
      }
    } on ServerException catch (e) {
      if (rollbackState != null) emit(rollbackState);
      emit(PlaylistError(message: e.message));
    } on NetworkException catch (e) {
      if (rollbackState != null) emit(rollbackState);
      emit(PlaylistError(message: e.message));
    } catch (_) {
      if (rollbackState != null) emit(rollbackState);
      emit(const PlaylistError(message: GeneralStrings.unexpectedError));
    }
  }
}
