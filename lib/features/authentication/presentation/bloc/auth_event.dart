part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCreateUserEvent extends AuthEvent {
  final String createdAt;
  final String name;
  final String avatar;

  const AuthCreateUserEvent({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  @override
  List<Object> get props => [createdAt, name, avatar];
}

class AuthGetUsersEvent extends AuthEvent {
  const AuthGetUsersEvent();
}
