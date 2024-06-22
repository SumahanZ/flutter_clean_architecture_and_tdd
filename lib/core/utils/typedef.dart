import 'package:flutter_clean_architecture_and_tdd/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef ResultVoid = Future<Either<Failure, void>>;
typedef ResultFuture<T> = Future<Either<Failure, T>>;
