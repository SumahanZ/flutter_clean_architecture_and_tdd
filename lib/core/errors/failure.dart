import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;
  final int statusCode;

  const Failure({required this.errorMessage, required this.statusCode});

  @override
  List<Object> get props => [errorMessage, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.errorMessage, required super.statusCode});
}
