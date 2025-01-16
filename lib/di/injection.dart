import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snappy/common/utils/preferences_helper.dart';
import 'package:snappy/config/route/router.dart';
import 'package:snappy/data/datasources/local/database_helper.dart';
import 'package:snappy/data/datasources/story_local_datasource.dart';
import 'package:snappy/data/datasources/story_remote_datasource.dart';
import 'package:snappy/domain/usecases/auth_login_usecase.dart';
import 'package:snappy/domain/usecases/auth_register_usecase.dart';
import 'package:snappy/domain/usecases/story_add_usecase.dart';
import 'package:snappy/domain/usecases/story_get_all_usecase.dart';
import 'package:snappy/domain/usecases/story_get_detail_usecase.dart';
import 'package:snappy/presentation/bloc/detail_story/detail_story_bloc.dart';
import 'package:snappy/presentation/bloc/shared_preferences/shared_preference_bloc.dart';
import 'package:snappy/presentation/bloc/stories/story_bloc.dart';

import '../data/repositories/story_repository_impl.dart';
import '../domain/repositories/story_repository.dart';
import '../presentation/bloc/add_story/add_story_bloc.dart';

final getIt = GetIt.instance;

Future<void> injectionInit() async {
  // SharedPreferences
  getIt.registerLazySingletonAsync<SharedPreferences>(
        () async => await SharedPreferences.getInstance(),
  );

  // Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Helpers
  await getIt.isReady<SharedPreferences>();
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  getIt.registerLazySingleton<PreferencesHelper>(
        () => PreferencesHelper(sharedPreferences: getIt()),
  );

  // AppRouter
  getIt.registerLazySingleton<AppRouter>(
        () => AppRouter(preferencesHelper: getIt()),
  );

  // DATA LAYER
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

  // DOMAIN LAYER
  // usecases
  getIt.registerLazySingleton(() => GetAllStory(getIt()));
  getIt.registerLazySingleton(() => GetDetailStory(getIt()));
  getIt.registerLazySingleton(() => AddStory(getIt()));
  getIt.registerLazySingleton(() => LoginAuth(getIt()));
  getIt.registerLazySingleton(() => RegisterAuth(getIt()));

  // PRESENTATION LAYER
  // bloc
  getIt.registerLazySingleton(() => AddStoryBloc(addStoryUseCase: getIt()));
  getIt.registerLazySingleton(() =>
      DetailStoryBloc(storyGetDetailUseCase: getIt()));
  getIt.registerLazySingleton(() => StoryBloc(storyGetAllUseCase: getIt()));
  getIt.registerLazySingleton(() =>
      SharedPreferenceBloc(preferencesHelper: getIt()));
}
