import 'dart:convert';

import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/models/user_model.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testModel = UserModel.empty();
  //raw json
  final testJson = fixture("test/fixtures/user.json");
  //map
  final testMap = jsonDecode(testJson) as Map<String, dynamic>;
  group("User Model", () {
    test("should be a subclass of [User] entity", () {
      //Arrange

      //we dont act because no function is run

      //Assert
      expect(testModel, isA<User>());
    });

    test("fromMap should return a [UserModel] with the right data", () {
      //Arrange

      //Act
      final result = UserModel.fromMap(testMap);
      //Assert
      expect(testModel, result);
    });

    test("fromJson should return a [UserModel] with the right data", () {
      //Arrange

      //Act
      final result = UserModel.fromJson(testJson);
      //Assert
      expect(testModel, result);
    });

    test("toJson should return a [String] from the [UserModel]", () {
      final result = testModel.toJson();
      final testJson = jsonEncode({
          "id": "",
          "createdAt": "",
          "name": "",
          "avatar": ""
      });
    
      expect(result, testJson);
    });

    test("toMap should return a [Map] from the [UserModel]", () {
      final result = testModel.toMap();

      expect(result, testMap);
    });

    test("copyWith should return a [UserModel] with a different data", () {
      //Act
      final result = testModel.copyWith(name: "Paul");
      //Assert
      expect(result.name, "Paul");
    });
  });
}
