import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snappy/di/injection.dart';
import 'package:snappy/presentation/bloc/add_story/add_story_bloc.dart';
import 'package:snappy/presentation/bloc/detail_story/detail_story_bloc.dart';
import 'package:snappy/presentation/bloc/shared_preferences/shared_preference_bloc.dart';
import 'package:snappy/presentation/bloc/stories/story_bloc.dart';

import 'bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injectionInit();
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
          ],
        ),
      ),
    );
  }
}
