import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_and_tdd/core/errors/exception.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  final int statusCode;

  const Failure({required this.errorMessage, required this.statusCode});

  //computed property (getter)
  String get message => "$statusCode Error: $errorMessage";

  @override
  List<Object> get props => [errorMessage, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.errorMessage, required super.statusCode});

  factory ApiFailure.fromException(ServerException serverException) {
    return ApiFailure(
      errorMessage: serverException.message,
      statusCode: serverException.statusCode,
    );
  }
}
