import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snappy/data/datasources/local/database_helper.dart';
import 'package:snappy/data/datasources/story_local_datasource.dart';
import 'package:snappy/data/datasources/story_remote_datasource.dart';
import 'package:snappy/domain/usecases/auth_login_usecase.dart';
import 'package:snappy/domain/usecases/auth_register_usecase.dart';
import 'package:snappy/domain/usecases/story_add_usecase.dart';
import 'package:snappy/domain/usecases/story_get_all_usecase.dart';
import 'package:snappy/domain/usecases/story_get_detail_usecase.dart';

import '../data/repositories/story_repository_impl.dart';
import '../domain/repositories/story_repository.dart';

final getIt = GetIt.instance;

void injectionInit() {
  // common
  getIt.registerLazySingletonAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });
  getIt.registerLazySingleton<Dio>(() => Dio());

  // helper
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // data layer
  // datasource
  getIt.registerLazySingleton<StoryRemoteDataSource>(
    () => StoryRemoteDataSourceImpl(dio: getIt(), preferencesHelper: getIt()),
  );
  getIt.registerLazySingleton<StoryLocalDataSource>(
    () => StoryLocalDataSourceImpl(databaseHelper: getIt()),
  );

  // repository
  getIt.registerLazySingleton<StoryRepository>(
    () => StoryRepositoryImpl(
      storyRemoteDataSource: getIt(),
      storyLocalDataSource: getIt(),
    ),
  );

  // domain layer
  // usecases
  getIt.registerLazySingleton(() => GetAllStory(getIt()));
  getIt.registerLazySingleton(() => GetDetailStory(getIt()));
  getIt.registerLazySingleton(() => AddStory(getIt()));
  getIt.registerLazySingleton(() => LoginAuth(getIt()));
  getIt.registerLazySingleton(() => RegisterAuth(getIt()));

  // presentation layer
}
