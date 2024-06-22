import 'package:flutter_clean_architecture_and_tdd/core/utils/typedef.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';

//we will not return exception, that is returned from the data layer in the domain layer. We return Right()/Void/class or Left()/failures something we created
//the data layer will throw an exception

//return failure class instead of APIFailure, etc
// (dependency inversion)
abstract interface class AuthenticationRepository {
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}
