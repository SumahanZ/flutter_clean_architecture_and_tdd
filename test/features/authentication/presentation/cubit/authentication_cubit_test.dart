import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_and_tdd/core/errors/failure.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/get_users.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthCubit cubit;

  const testCreateUserParams = CreateUserParams.empty();

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(testCreateUserParams);
  });

  //after each test done we want to destroy the bloc
  //we want to close it
  tearDown(() => cubit.close());

  group("AuthCubit -", () {
    test("initial state should be [AuthInitial]", () async {
      //Cubit already lives we dont need arrange and act
      //thats why we use equatable so we can use expect
      expect(cubit.state, const AuthInitial());
    });

    group("createUser", () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthCreateUserActionState, AuthUserCreatedActionState] when [AuthCubit.createUser] is completed successfully.',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (_) => cubit.createUserHandler(
          createdAt: testCreateUserParams.createdAt,
          name: testCreateUserParams.name,
          avatar: testCreateUserParams.avatar,
        ),
        verify: (_) {
          verify(() => createUser(testCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
        expect: () => [
          isA<AuthCreateUserActionState>(),
          isA<AuthUserCreatedActionState>()
        ],
      );
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthCreateUserActionState, AuthError] when [AuthCubit.createUser] is not completed successfully.',
        build: () {
          when(() => createUser(any())).thenAnswer((_) async => const Left(
              ApiFailure(errorMessage: "Something happened", statusCode: 500)));
          return cubit;
        },
        act: (cubit) => cubit.createUserHandler(
          createdAt: testCreateUserParams.createdAt,
          name: testCreateUserParams.name,
          avatar: testCreateUserParams.avatar,
        ),
        verify: (_) {
          verify(() => createUser(testCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        },
        expect: () => [
          isA<AuthCreateUserActionState>(),
          isA<AuthError>(),
        ],
      );
    });

    group("getUsers", () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthGettingUsersActionState, AuthLoaded] when [AuthCubit.getUsers] is fetched successfully.',
        build: () {
          when(() => getUsers()).thenAnswer((_) async => const Right([]));
          return cubit;
        },
        act: (cubit) => cubit.getUsersHandler(),
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        },
        expect: () => [
          isA<AuthGettingUsersActionState>(),
          isA<AuthLoaded>(),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthGettingUsersActionState, AuthError] when [AuthCubit.getUsers] is not completed successfully.',
        build: () {
          when(() => getUsers()).thenAnswer((_) async => const Left(
              ApiFailure(errorMessage: "Something happened", statusCode: 500)));
          return cubit;
        },
        act: (cubit) => cubit.getUsersHandler(),
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        },
        expect: () => [
          isA<AuthGettingUsersActionState>(),
          isA<AuthError>(),
        ],
      );
    });
  });
}
