//remote data source we are only return one datatype dont handle Either here, because, if we get an exception, we will throw an error not handle (try/catching) it

//in datasource we are exclusively using/returning the model
//but on other layers we are using the entity from the domain layer instead
//and the toMap, fromJSON are functionalities only present in the model

//we want it to be loosely coupled as possible

import 'dart:convert';

import 'package:flutter_clean_architecture_and_tdd/core/errors/exception.dart';
import 'package:flutter_clean_architecture_and_tdd/core/utils/constants.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/models/user_model.dart';
import "package:http/http.dart" as http;

abstract interface class AuthenticationRemoteDataSource {
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});
  Future<List<UserModel>> getUsers();
}

//this is higher level up we will check the http.client or the server/API, instead of the remote data source in the repository
//Testing  Principles
//Check to make sure that it returns the right data when the response
//1. code is 200 or the proper response code (success)
//2. check to make sure that it can throw a custom exception with the right message when status code is the bad one
class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final http.Client _client;

  const AuthenticationRemoteDataSourceImpl(this._client);

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    //use the try catch to handle the dart errors
    try {
      final response =
          await _client.post(Uri.https(kBaseUrl, kCreateUsersEndpoint),
              body: jsonEncode({
                "createdAt": createdAt,
                "name": name,
              }),
              headers: {"Content-Type": "application/json"});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode,
          //if you thow in a try catch, it gets put into the catch (e)
          //we can rethrow in a try catch, so it doesnt get handled and rethrow it when another function call this, so that function needs to handle it
        );
      }
    } on ServerException {
      //general errors
      //for errors that is not in our control
      //error from requesterror for example
      //rethrow exit the function and make the repository to handle it
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response =
          await _client.get(Uri.https(kBaseUrl, kGetUsersEndpoint));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      return List<Map<String, dynamic>>.from(
              (jsonDecode(response.body) as List))
          .map((e) => UserModel.fromMap(e))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
