import 'package:flutter_clean_architecture_and_tdd/core/errors/exception.dart';
import 'package:flutter_clean_architecture_and_tdd/core/errors/failure.dart';
import 'package:flutter_clean_architecture_and_tdd/core/utils/typedef.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:fpdart/fpdart.dart';

//dependency injecton is done in the constructor
//instead of passing instance of datasource inside the constructor everytime,
//we can just inject it to the class
//so we don't have to make multiples instances and make it easily testable (able to be Mock and Stubbed)

//Repository will talk to the datasource

//Test Driven Development
//It is driven by tests, we are going to write our test first,

//Testing Principles
//How do Repository Impl test works?
//1. Call the remote data source
//2. Check if the method returns the proper data (when remoteDataSource throws an exception, we return a failure, and if it doesnt throw an exception, we return the actual expected data)
//(in repository we handle the error too, so we make a test case for it)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _remoteDataSource;

  const AuthenticationRepositoryImpl(this._remoteDataSource);

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ApiFailure(
        errorMessage: e.message,
        statusCode: e.statusCode,
      ));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    throw UnimplementedError();
  }
}
