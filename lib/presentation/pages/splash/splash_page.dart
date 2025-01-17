import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [SplashFooter(), SplashMain()],
      ),
    );
  }
}

class SplashMain extends StatelessWidget {
  const SplashMain({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SharedPreferenceBloc>().add(SharedPreferenceInitEvent());
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

          await Future.delayed(const Duration(seconds: 5), () {
            if (user != null) {
              if (context.mounted) context.go(PageRouteName.home);
            } else if (isFirstTime) {
              if (context.mounted) context.go(PageRouteName.onboarding);
            } else {
              if (context.mounted) context.go(PageRouteName.login);
            }
          });
        }
      },
      builder: (context, state) {
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
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.bold)),
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
    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.loose,
      children: [
        Positioned(
            top: -300,
            right: 20,
            child: Transform.rotate(angle: pi / 6,
                child: SvgPicture.asset(
                  "assets/images/splash_ilust.svg", width: MediaQuery
                    .of(context)
                    .size
                    .width + 200,))),
        Positioned(
            bottom: -200,
            left: 240,
            child: Transform.rotate(angle: 540,
                child: SvgPicture.asset(
                  "assets/images/splash_ilust.svg", width: MediaQuery
                    .of(context)
                    .size
                    .width + 200,))),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('from', style: Theme
                .of(context)
                .textTheme
                .labelLarge),
            Text(
              'Faradaii',
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }
}
