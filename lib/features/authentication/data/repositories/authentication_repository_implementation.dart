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

//Testing Principles for repository
//How do Repository Impl test works?
//1. Call the remote data source
//2. Check if the method returns the proper data (when remoteDataSource throws an exception, we return a failure, and if it doesnt throw an exception, we return the actual expected data)
//(in repository we handle the error too, so we make a test case for it)

//make APIFailure/ServerFailure/LocalFailure
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
      return Left(ApiFailure.fromException(e));
    }
  }

//write the test one step at a time dont do all the implementation at once, write enough so that a single step is passed one at a time
  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      return Right(users);
    } on ServerException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
