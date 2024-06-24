import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/get_users.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required CreateUser createUser, required GetUsers getUsers})
      : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthInitial());

  final CreateUser _createUser;
  final GetUsers _getUsers;

  void createUserHandler(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    emit(const AuthCreateUserActionState());
    final result = await _createUser(CreateUserParams(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
    ));

    result.fold(
      (l) => emit(AuthError(l.message)),
      (_) => emit(AuthUserCreatedActionState()),
    );
  }

  void getUsersHandler() async {
    emit(const AuthGettingUsersActionState());
    final result = await _getUsers();

    result.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthLoaded(r)),
    );
  }
}
