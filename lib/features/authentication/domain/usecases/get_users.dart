import 'package:flutter_clean_architecture_and_tdd/core/usecase/use_case.dart';
import 'package:flutter_clean_architecture_and_tdd/core/utils/typedef.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UseCaseNoParam<ResultFuture<List<User>>> {
  final AuthenticationRepository _authenticationRepository;

  GetUsers(this._authenticationRepository);

  @override
  ResultFuture<List<User>> call() {
    return _authenticationRepository.getUsers();
  }
}
