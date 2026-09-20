import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  const RegisterRequested(this.username, this.email, this.password);
  @override
  List<Object?> get props => [username, email, password];
}

class LogoutRequested extends AuthEvent {}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String otp;
  const VerifyEmailRequested(this.email, this.otp);
  @override
  List<Object?> get props => [email, otp];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  const ForgotPasswordRequested(this.email);
  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;
  const ResetPasswordRequested(this.email, this.otp, this.newPassword);
  @override
  List<Object?> get props => [email, otp, newPassword];
}
