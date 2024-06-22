//create our own errors we dont wanna use the raw and throw it

import 'package:equatable/equatable.dart';

//the original exception doesnt have statusCode
//part of the reason why we made our own exception
class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, required this.statusCode});

  final int statusCode;
  final String message;
  
  @override
  List<Object?> get props => [statusCode, message];
}
