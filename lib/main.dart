import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/config/route/router.dart';
import 'package:snappy/di/injection.dart';
import 'package:snappy/presentation/bloc/add_story/add_story_bloc.dart';
import 'package:snappy/presentation/bloc/detail_story/detail_story_bloc.dart';
import 'package:snappy/presentation/bloc/shared_preferences/shared_preference_bloc.dart';
import 'package:snappy/presentation/bloc/stories/story_bloc.dart';

import 'bloc_observer.dart';
import 'config/theme/theme.dart';
import 'config/theme/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectionInit();
  Bloc.observer = MyObserver();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<AddStoryBloc>()),
      BlocProvider(create: (context) => getIt<StoryBloc>()),
      BlocProvider(create: (context) => getIt<DetailStoryBloc>()),
      BlocProvider(create: (context) => getIt<SharedPreferenceBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View
        .of(context)
        .platformDispatcher
        .platformBrightness;
    TextTheme textTheme = createTextTheme(
        context, "Poppins", "Plus Jakarta Sans");

    MaterialTheme theme = MaterialTheme(textTheme);
    AppRouter appRouter = getIt<AppRouter>();
    return MaterialApp.router(
      routerConfig: appRouter.router,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
    );
  }
}