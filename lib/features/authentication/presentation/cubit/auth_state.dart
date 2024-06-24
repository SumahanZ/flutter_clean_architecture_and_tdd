part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

sealed class AuthActionState extends AuthState {
  const AuthActionState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoaded extends AuthState {
  const AuthLoaded(this.users);

  final List<User> users;

  @override
  //we differentiate the list of users based on the id
  List<Object> get props => users.map((user) => user.id).toList();
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

//Action State
final class AuthCreateUserActionState extends AuthState {
  const AuthCreateUserActionState();
  @override
  List<Object> get props => [];
}

final class AuthGettingUsersActionState extends AuthState {
  const AuthGettingUsersActionState();
  @override
  List<Object> get props => [];
}

final class AuthUserCreatedActionState extends AuthState {
  @override
  List<Object> get props => [];
}
