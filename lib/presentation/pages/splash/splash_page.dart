import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/config/route/router.dart';
import 'package:snappy/presentation/bloc/shared_preferences/shared_preference_bloc.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [SplashMain(), SplashFooter()],
      ),
    );
  }
}

class SplashMain extends StatelessWidget {
  const SplashMain({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SharedPreferenceBloc, SharedPreferenceState>(
      listener: (BuildContext context, SharedPreferenceState state) async {
        if (state is SharedPreferenceErrorState) {
          print(state.errorMessage);
        }
        if (state is SharedPreferenceLoadedState) {
          if (!context.mounted) return;
          print('State Loaded: User - ${state.savedUser}, isFirstTime - ${state
              .isFirstTime}');
          final user = state.savedUser;
          final isFirstTime = state.isFirstTime ?? false;

          await Future.delayed(const Duration(seconds: 2), () {
            if (user != null) {
              context.go(PageRouteName.home);
            } else if (isFirstTime) {
              context.go(PageRouteName.onboarding);
            } else {
              context.go(PageRouteName.login);
            }
          });
        }
      },
      builder: (context, state) {
        Future.delayed(const Duration(seconds: 2), () {
          context.read<SharedPreferenceBloc>().add(SharedPreferenceInitEvent());
        });
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("assets/snappy.png", fit: BoxFit.cover),
              ),
            ),
            Text('Snappy', style: Theme
                .of(context)
                .textTheme
                .displaySmall),
          ],
        );
      },
    );
  }
}

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('from', style: Theme.of(context).textTheme.labelLarge),
        Text(
          'Faradaii',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
