import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/presentation/pages/login/login_page.dart';

import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/splash/splash_page.dart';

abstract class PageRouteName {
  static const home = '/';
  static const detail = '/detail/:id';
  static const add = '/add';
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
}

class AppRouter {
  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    initialLocation: PageRouteName.splash,
    routes: [
      GoRoute(
        path: PageRouteName.home,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("home")))),
            ),
      ),
      GoRoute(
        path: PageRouteName.detail,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("det")))),
            ),
      ),
      GoRoute(
        path: PageRouteName.login,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: LoginPage())),
            ),
      ),
      GoRoute(
        path: PageRouteName.register,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("reg")))),
            ),
      ),
      GoRoute(
        path: PageRouteName.add,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("add")))),
            ),
      ),
      GoRoute(
        path: PageRouteName.onboarding,
        pageBuilder: (_, state) => MaterialPage(child: OnboardingPage()),
      ),
      GoRoute(
        path: PageRouteName.splash,
        pageBuilder:
            (_, state) => MaterialPage(
              child: SplashPage(),
            ),
      ),
    ],
  );
}
