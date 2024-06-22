import 'package:flutter_clean_architecture_and_tdd/core/errors/failure.dart';
import 'package:flutter_clean_architecture_and_tdd/core/usecase/use_case.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/repositories/authentication_repository.dart';
import 'authentication_repository.mock.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/usecases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late GetUsers usecase;
  late AuthenticationRepository authRepo;

  setUp(() {
    authRepo = MockAuthRepository();
    usecase = GetUsers(authRepo);
  });

  group("Get User Usecase", () {
    final testResponse = [User.empty()];
    test("should call the [AuthRepo.getUsers] and return [List<User>]",
        () async {
      when(() => authRepo.getUsers())
          .thenAnswer((_) async => Right(testResponse));

      //Act
      final result = await usecase(NoParam());

      //Assert
      expect(result, isA<Right<Failure, List<User>>>());
      verify(() => authRepo.getUsers()).called(1);
      verifyNoMoreInteractions(authRepo);
    });
  });
}
