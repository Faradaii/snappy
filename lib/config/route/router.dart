import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/common/utils/preferences_helper.dart';

abstract class PageRoute {
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
  final PreferencesHelper preferencesHelper;

  AppRouter({required this.preferencesHelper});

  late final GoRouter _goRouter = GoRouter(
    initialLocation: PageRoute.splash,
    routes: [
      GoRoute(
        path: PageRoute.home,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("home")))),
            ),
      ),
      GoRoute(
        path: PageRoute.detail,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("det")))),
            ),
      ),
      GoRoute(
        path: PageRoute.login,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("login")))),
            ),
      ),
      GoRoute(
        path: PageRoute.register,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("reg")))),
            ),
      ),
      GoRoute(
        path: PageRoute.add,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("add")))),
            ),
      ),
      GoRoute(
        path: PageRoute.onboarding,
        pageBuilder:
            (_, state) => MaterialPage(
              child: (Scaffold(body: SafeArea(child: Text("onb")))),
            ),
      ),
      GoRoute(
        path: PageRoute.splash,
        pageBuilder: (_, state) {
          Future.delayed(const Duration(seconds: 3), () {
            // After 3 seconds, navigate to the home screen
            _goRouter.go(PageRoute.home);
          });
          return MaterialPage(child: Text('splash'));
        },
      ),
    ],
    redirect: (context, state) async {
      final user = await preferencesHelper.getSavedUser();
      final isFirstTime = await preferencesHelper.getIsFirstTime();
      if (user != null) {
        return PageRoute.home;
      } else if (isFirstTime) {
        return PageRoute.onboarding;
      } else {
        return PageRoute.login;
      }
    },
  );
}
