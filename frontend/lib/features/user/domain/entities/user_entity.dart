import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String profilePictureUrl;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
    required this.profilePictureUrl,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, username, email, bio, profilePictureUrl];
}
