import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/config/route/router.dart';

import '../../../common/utils/preferences_helper.dart';

class SplashPage extends StatefulWidget {
  final PreferencesHelper preferencesHelper;

  const SplashPage({super.key, required this.preferencesHelper});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = await widget.preferencesHelper.getSavedUser();
    final isFirstTime = await widget.preferencesHelper.getIsFirstTime();

    if (user != null) {
      if (mounted) context.go(PageRouteName.home);
    } else if (isFirstTime) {
      if (mounted) context.go(PageRouteName.onboarding);
    } else {
      if (mounted) context.go(PageRouteName.login);
    }
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
        Text('Snappy', style: Theme.of(context).textTheme.displaySmall),
      ],
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
