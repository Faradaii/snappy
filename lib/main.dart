import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/config/flavor/flavor_config.dart';
import 'package:snappy/config/route/router.dart';
import 'package:snappy/di/injection.dart';
import 'package:snappy/presentation/bloc/add_story/add_story_bloc.dart';
import 'package:snappy/presentation/bloc/auth/auth_bloc.dart';
import 'package:snappy/presentation/bloc/detail_story/detail_story_bloc.dart';
import 'package:snappy/presentation/bloc/shared_preferences/shared_preference_bloc.dart';
import 'package:snappy/presentation/bloc/stories/story_bloc.dart';

import 'bloc_observer.dart';
import 'common/localizations/common.dart';
import 'common/url/url_strategy_other.dart';
import 'config/theme/theme.dart';
import 'config/theme/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectionInit();
  Bloc.observer = MyObserver();

  FlavorConfig(
    flavor: FlavorType.free,
    values: const FlavorValues(statusSubscription: "Free Subscription"),
  );

  usePathUrlStrategy();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => getIt<AddStoryBloc>()),
      BlocProvider(create: (context) => getIt<StoryBloc>()),
      BlocProvider(create: (context) => getIt<DetailStoryBloc>()),
      BlocProvider(create: (context) => getIt<SharedPreferenceBloc>()),
      BlocProvider(create: (context) => getIt<AuthBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme =
        createTextTheme(context, "Poppins", "Plus Jakarta Sans");

    MaterialTheme theme = MaterialTheme(textTheme);
    AppRouter appRouter = getIt<AppRouter>();
    return BlocBuilder<SharedPreferenceBloc, SharedPreferenceState>(
      builder: (context, state) => MaterialApp.router(
        locale: state.language,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter.router,
        theme: theme.light(),
        darkTheme: theme.dark(),
      ),
    );
  }
}
