import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/repositories/authentication_repository.dart';
import 'authentication_repository.mock.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

//unit test we are going to test a single unit which are the class
//we are going to test the functionality or the methods

//when we unit test ask this 3 questions:
//1. What does the class depend on -> AuthenticationRepository? (the dependencies)
//2. How can we create a fake version of the dependencies -> (Mock) (we want to control how the dependencies functions) (we dont wanna make a true call)
//3. How do we control what our dependencies do -> (Stubbing)

void main() {
  late CreateUser usecase;
  late AuthenticationRepository authRepo;
  // registerFallbackValue(Football());

  setUp(() {
    authRepo = MockAuthRepository();
    usecase = CreateUser(authRepo);
  });

  const params = CreateUserParams.empty();
  group("Create User Usecase", () {
    test("should call the [AuthRepo.createUser]", () async {
      //Arrange what we need before acting on the function we want to test (stubbing the higher level, we dont stub the usecase since the usecase is just calling the passed on repository method)

      //any only works on primite datatypes on Dart and positional arguments
      //any means any value that matches the type
      //for name arguments add named:
      //if it is custom object it will find a fallback value that we register and use that: refer to line 19

      //we will hijack the president, so mr president we are gonna make you answer this
      //Future function use thenAnswer
      //Not future function use thenReturn
      //Deliberately throw error thenThrow
      //when void is returned just put in null
      when(() => authRepo.createUser(
              createdAt: any(named: "createdAt"),
              name: any(named: "name"),
              avatar: any(named: "avatar")))
          .thenAnswer((_) async => const Right(null));
      //Act
      final result = await usecase(params);
      //Assert
      expect(result, const Right(null));

      //verify that the usecase make the call, what if the history was faked?, therefore we need to verify it.
      //make sure the call is called exactly once
      verify(() => authRepo.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar)).called(1);

      //after the call that we are testing went through, we wanna make sure the repository/dependencies is not interacted with again
      verifyNoMoreInteractions(authRepo);
    });
  });
}
