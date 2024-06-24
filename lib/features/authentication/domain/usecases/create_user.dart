import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_and_tdd/core/usecase/use_case.dart';
import 'package:flutter_clean_architecture_and_tdd/core/utils/typedef.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/repositories/authentication_repository.dart';

//the only thing in the domain layer that can be tested is the use case because it has actual implementation.
//entity and repository (domain) not tested because it is abstract/interface it is just the blueprint and contract.
//however we will test the implementation of this blueprint and model which are model and repository in the data layer
class CreateUser extends UseCase<ResultVoid, CreateUserParams> {
  final AuthenticationRepository _authenticationRepository;

  CreateUser(this._authenticationRepository);

  @override
  ResultVoid call(CreateUserParams params) {
    return _authenticationRepository.createUser(
        createdAt: params.createdAt, name: params.name, avatar: params.avatar);
  }
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams.empty() : this(createdAt: "", name: "", avatar: "");

  const CreateUserParams(
      {required this.createdAt, required this.name, required this.avatar});

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
