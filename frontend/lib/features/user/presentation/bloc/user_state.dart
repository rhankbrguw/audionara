import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  const UserLoaded({required this.user});

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class UserPasswordChanged extends UserState {
  const UserPasswordChanged();
}

class UserError extends UserState {
  final String message;
  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
