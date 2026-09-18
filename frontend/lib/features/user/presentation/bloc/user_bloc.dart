import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/user_repository.dart';
import '../../../../core/errors/exceptions.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(const UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ChangeUserPassword>(_onChangeUserPassword);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final user = await repository.getProfile();
      emit(UserLoaded(user: user));
    } catch (e) {
      if (e is ServerException) {
        emit(UserError(message: e.message));
      } else if (e is NetworkException) {
        emit(UserError(message: e.message));
      } else {
        emit(const UserError(message: 'Failed to load profile. Please try again.'));
      }
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserState> emit,
  ) async {
    UserLoaded? previousState;
    if (state is UserLoaded) {
      previousState = state as UserLoaded;
    }
    emit(const UserLoading());
    try {
      final existingUrl = previousState?.user.profilePictureUrl ?? '';
      final updatedUser = await repository.updateProfile(
        event.bio,
        event.profilePictureFilePath,
        username: event.username,
        email: event.email,
        existingProfilePictureUrl: existingUrl,
      );
      emit(UserLoaded(user: updatedUser));
    } catch (e) {
      if (previousState != null) emit(previousState);
      if (e is ServerException) {
        emit(UserError(message: e.message));
      } else if (e is NetworkException) {
        emit(UserError(message: e.message));
      } else {
        emit(const UserError(message: 'Failed to update profile. Please try again.'));
      }
    }
  }

  Future<void> _onChangeUserPassword(
    ChangeUserPassword event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());
    try {
      await repository.changePassword(event.currentPassword, event.newPassword);
      emit(const UserPasswordChanged());
    } catch (e) {
      if (e is ServerException) {
        emit(UserError(message: e.message));
      } else if (e is NetworkException) {
        emit(UserError(message: e.message));
      } else {
        emit(const UserError(message: 'Failed to change password.'));
      }
    }
  }
}
