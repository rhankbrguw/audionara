import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;
  const AuthAuthenticated(this.username);
  @override
  List<Object?> get props => [username];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthRegistrationSuccess extends AuthState {
  final String email;
  const AuthRegistrationSuccess(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthVerificationSuccess extends AuthState {}

class AuthPasswordResetSent extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {}
