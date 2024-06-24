abstract class UseCase<Result, Params> {
  const UseCase();
  Result call(Params params);
}

abstract class UseCaseNoParam<Result> {
  const UseCaseNoParam();
  Result call();
}
