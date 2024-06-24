import "dart:convert";

import "package:flutter_clean_architecture_and_tdd/core/errors/exception.dart";
import "package:flutter_clean_architecture_and_tdd/core/utils/constants.dart";
import "package:flutter_clean_architecture_and_tdd/features/authentication/data/datasources/authentication_remote_data_source.dart";
import "package:flutter_clean_architecture_and_tdd/features/authentication/data/models/user_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:mocktail/mocktail.dart";

//we can mock dependencies from external libraries not only class we create
class MockHTTPClient extends Mock implements http.Client {}

void main() {
  //always make dependencies private
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockHTTPClient();
    remoteDataSource = AuthenticationRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });

  group("Authentication Remote Data Source - ", () {
    group("createUser", () {
      test("should complete successfully when the status code is 200 or 201",
          () async {
        //Arrange
        //use any to match instead of deliberately passing the url only in the stub
        when(() => client.post(any(), body: any(named: "body"))).thenAnswer(
            (_) async => http.Response("User created successfully", 201));

        //Act
        //Save the method because it returns a void, we cant expect void
        final methodCall = remoteDataSource.createUser;

        //Assert
        //expect: make sure that when the method is called with these values is completed successfully (completes keyword)
        expect(
            methodCall(createdAt: "createdAt", name: "name", avatar: "avatar"),
            //only call completes on Future<> stuff
            completes);

        //the values matches which are passed in the function call
        verify(
          () => client.post(
            Uri.https(kBaseUrl, kCreateUsersEndpoint),
            body: jsonEncode({
              "createdAt": "createdAt",
              "name": "name",
              "avatar": "avatar",
            }),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      });

      //when you test an exception never invoke it but save it
      test("should throw [APIException] when the status code is not 200 or 201",
          () async {
        //Arrange
        when(() => client.post(any(), body: any(named: "body"))).thenAnswer(
            (_) async => http.Response("Invalid credentials passed", 400));

        //Act
        //never await when testing for the exception
        final methodCall = remoteDataSource.createUser;

        //Assert
        expect(
          methodCall(createdAt: "createdAt", name: "name", avatar: "avatar"),
          throwsA(
            const ServerException(
                message: "Invalid credentials passed", statusCode: 400),
          ),
        ); //this or just obliterate and call await

        verify(
          () => client.post(
            Uri.https(kBaseUrl, kCreateUsersEndpoint),
            body: jsonEncode({
              "createdAt": "createdAt",
              "name": "name",
              "avatar": "avatar",
            }),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      });
    });

    group("getUsers", () {
      test("should return [List<UserModel>] when the status code is 200 or 201",
          () async {
        final List<UserModel> testUsers = [UserModel.empty()];
        //Arrange
        when(() => client.get(any())).thenAnswer((_) async =>
            http.Response(jsonEncode([testUsers.first.toMap()]), 200));
        //Act
        final result = await remoteDataSource.getUsers();
        //Assert
        expect(result, testUsers);
        verify(
          () => client.get(Uri.https(kBaseUrl, kGetUsersEndpoint)),
        ).called(1);
        verifyNoMoreInteractions(client);
      });

      test("should throw [APIException] when the status code is not 200 or 201",
          () async {
        //Arrange
        when(() => client.get(any())).thenAnswer(
            (_) async => http.Response("Something wrong happened", 400));
        //Act
        final result = remoteDataSource.getUsers();
        //Assert
        expect(
            result,
            throwsA(const ServerException(
                message: "Something wrong happened", statusCode: 400)));
        verify(
          () => client.get(Uri.https(kBaseUrl, kGetUsersEndpoint)),
        ).called(1);
        verifyNoMoreInteractions(client);
      });
    });
  });
}
