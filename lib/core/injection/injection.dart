import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/usecases/get_users.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import "package:http/http.dart" as http;

part "injection_main.dart";
