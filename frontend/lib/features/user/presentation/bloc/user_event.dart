import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser();
}

class UpdateUserProfile extends UserEvent {
  final String username;
  final String email;
  final String bio;
  final String profilePictureFilePath;

  const UpdateUserProfile({
    this.username = '',
    this.email = '',
    required this.bio,
    required this.profilePictureFilePath,
  });

  @override
  List<Object?> get props => [username, email, bio, profilePictureFilePath];
}

class ChangeUserPassword extends UserEvent {
  final String currentPassword;
  final String newPassword;

  const ChangeUserPassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}
