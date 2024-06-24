import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/get_users.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required CreateUser createUser, required GetUsers getUsers})
      : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthInitial()) {
    on<AuthCreateUserEvent>(_createUserHandler);
    on<AuthGetUsersEvent>(_getUsersHandler);
  }

//take in the usecases
  final CreateUser _createUser;
  final GetUsers _getUsers;

  FutureOr<void> _createUserHandler(
      AuthCreateUserEvent event, Emitter<AuthState> emit) async {
    final result = await _createUser(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));

    result.fold(
      (l) => emit(AuthError(l.message)),
      (_) => emit(AuthUserCreatedActionState()),
    );
  }

  FutureOr<void> _getUsersHandler(
      AuthGetUsersEvent event, Emitter<AuthState> emit) async {
    final result = await _getUsers();

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthLoaded(r)),
    );
  }
}
