part of "injection.dart";

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //registerfactory is for the top level: Cubit/Bloc
  //registerLazySingleton is for the dependencies
  //sl() means find me where i initialized the dependencies, like pattern matching any()
  sl
    //App Business Logic
    ..registerFactory(() => AuthCubit(createUser: sl(), getUsers: sl()))

    //Usecases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    //Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(sl()))

    //Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImpl(sl()))

    //External Dependencies (from outside world/package/library)
    ..registerLazySingleton(() => http.Client());
}
