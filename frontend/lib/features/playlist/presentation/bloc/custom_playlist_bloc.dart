import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/custom_playlist_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_strings.dart';
import '../../domain/entities/custom_playlist_track_entity.dart';
import '../../domain/entities/custom_playlist_entity.dart';
import 'custom_playlist_event.dart';
import 'custom_playlist_state.dart';

part 'custom_playlist_bloc_handlers.dart';
part 'custom_playlist_bloc_handlers_write.dart';

class CustomPlaylistBloc
    extends Bloc<CustomPlaylistEvent, CustomPlaylistState> {
  CustomPlaylistBloc({required this.repository})
    : super(CustomPlaylistInitial()) {
    on<FetchCustomPlaylistsRequested>((e, emit) => onFetchPlaylists(e, emit));
    on<CreateCustomPlaylistRequested>((e, emit) => onCreatePlaylist(e, emit));
    on<UpdateCustomPlaylistRequested>((e, emit) => onUpdatePlaylist(e, emit));
    on<DeleteCustomPlaylistRequested>((e, emit) => onDeletePlaylist(e, emit));
    on<FetchCustomPlaylistTracksRequested>((e, emit) => onFetchPlaylistTracks(e, emit));
    on<AddTrackToCustomPlaylistRequested>((e, emit) => onAddTrack(e, emit));
    on<RemoveTrackFromCustomPlaylistRequested>((e, emit) => onRemoveTrack(e, emit));
  }

  final CustomPlaylistRepository repository;

  void emitError(Object e, Emitter<CustomPlaylistState> emit) {
    if (e is ServerException) {
      emit(CustomPlaylistError(message: e.message));
    } else if (e is NetworkException) {
      emit(CustomPlaylistError(message: e.message));
    } else {
      emit(const CustomPlaylistError(message: GeneralStrings.unexpectedError));
    }
  }
}
