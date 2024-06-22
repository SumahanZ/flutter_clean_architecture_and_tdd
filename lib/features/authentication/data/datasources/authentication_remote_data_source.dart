//remote data source we are only return one datatype dont handle Either here, because, if we get an exception, we will throw an error not handle (try/catching) it

//in datasource we are exclusively using/returning the model
//but on other layers we are using the entity from the domain layer instead
//and the toMap, fromJSON are functionalities only present in the model

//we want it to be loosely coupled as possible

import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/models/user_model.dart';

abstract interface class AuthenticationRemoteDataSource {
  Future<void> createUser({required String createdAt, required String name, required String avatar});
  Future<List<UserModel>> getUsers();
}