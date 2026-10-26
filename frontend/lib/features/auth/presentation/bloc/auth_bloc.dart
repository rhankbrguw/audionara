import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/general_strings.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<VerifyEmailRequested>(_onVerifyEmailRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  final AuthRepository repository;

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    if (repository.isLoggedIn) {
      emit(AuthAuthenticated(repository.currentUsername ?? 'User'));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.login(event.email, event.password);
      emit(AuthAuthenticated(repository.currentUsername ?? 'User'));
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(e.message));
      } else if (e is NetworkException) {
        emit(AuthError(e.message));
      } else {
        emit(const AuthError(GeneralStrings.unexpectedError));
      }
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.register(event.username, event.email, event.password);
      emit(AuthRegistrationSuccess(event.email));
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(e.message));
      } else if (e is NetworkException) {
        emit(AuthError(e.message));
      } else {
        emit(const AuthError(GeneralStrings.unexpectedError));
      }
    }
  }

  Future<void> _onVerifyEmailRequested(
    VerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.verifyEmail(event.email, event.otp);
      emit(AuthVerificationSuccess());
      emit(AuthAuthenticated(repository.currentUsername ?? 'User'));
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(e.message));
      } else if (e is NetworkException) {
        emit(AuthError(e.message));
      } else {
        emit(const AuthError(GeneralStrings.unexpectedError));
      }
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.forgotPassword(event.email);
      emit(AuthPasswordResetSent());
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(e.message));
      } else if (e is NetworkException) {
        emit(AuthError(e.message));
      } else {
        emit(const AuthError(GeneralStrings.unexpectedError));
      }
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await repository.resetPassword(event.email, event.otp, event.newPassword);
      emit(AuthPasswordResetSuccess());
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(e.message));
      } else if (e is NetworkException) {
        emit(AuthError(e.message));
      } else {
        emit(const AuthError(GeneralStrings.unexpectedError));
      }
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(AuthUnauthenticated());
  }
}
