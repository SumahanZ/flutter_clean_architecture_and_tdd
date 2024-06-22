import 'package:flutter_clean_architecture_and_tdd/core/errors/exception.dart';
import 'package:flutter_clean_architecture_and_tdd/core/errors/failure.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

//Only mock our dependencies
class MockAuthRemoteDataSourceImpl extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource authRemoteDataSource;
  late AuthenticationRepository authRepo;
  setUp(() {
    authRemoteDataSource = MockAuthRemoteDataSourceImpl();
    authRepo = AuthenticationRepositoryImpl(authRemoteDataSource);
  });

  const testException =
      ServerException(message: "Unknown Error Occured", statusCode: 500);

  group("Authentication Repository -", () {
    group("createUser", () {
      const createdAt = "createdAt";
      const name = "name";
      const avatar = "avatar";
      test(
          "should call the [RemoteDataSource.createUser] and complete successfully when the call to the remote source is successful",
          () async {
        //whenever you are returning void use Future.value
        //we are testing for success so we always ensuring it returns success by controlling it (Stubbing and Mock)

        //Arrange
        when(() => authRemoteDataSource.createUser(
                createdAt: any(named: "createdAt"),
                name: any(named: "name"),
                avatar: any(named: "avatar")))
            .thenAnswer((_) async => Future.value());

        //Act
        final result = await authRepo.createUser(
            createdAt: createdAt, name: name, avatar: avatar);

        //Assert
        expect(result, const Right(null));
        verify(() => authRemoteDataSource.createUser(
            createdAt: createdAt, name: name, avatar: avatar)).called(1);
        verifyNoMoreInteractions(authRemoteDataSource);
      });

      test(
          "should call the [RemoteDataSource.createUser] and complete unsuccessfully",
          () async {
        //whenever you are returning void use Future.value
        //we are testing for success so we always ensuring it returns success by controlling it (Stubbing and Mock)

        //Arrange
        when(() => authRemoteDataSource.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar"))).thenThrow(testException);

        //Act
        final result = await authRepo.createUser(
            createdAt: createdAt, name: name, avatar: avatar);

        //We are stubbing on the call of createUser for remote datasource with throw ServerException
        //In the authRepo.createUser it will handle the ServerException and return a ServerFailure
        //Assert
        //We wanna make sure our Failure has the same message and statuscode as the exception
        expect(
          result,
          Left(
            ApiFailure(
              errorMessage: testException.message,
              statusCode: testException.statusCode,
            ),
          ),
        );
        verify(() => authRemoteDataSource.createUser(
            createdAt: createdAt, name: name, avatar: avatar)).called(1);
        verifyNoMoreInteractions(authRemoteDataSource);
      });
    });
  });
}
