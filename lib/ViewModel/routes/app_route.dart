import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locaface/View/attendance_view.dart';
import 'package:locaface/ViewModel/component/error_view.dart';

import '../../View/login_view.dart';
import '../../View/main_view.dart';
import '../../View/splash_view.dart';

class AppRoute {
  final GoRouter router;
  AppRoute()
    : router = GoRouter(
        navigatorKey: GlobalKey<NavigatorState>(),
        debugLogDiagnostics: true,
        errorBuilder: (context, state) {
          return ErrorView(error: state.error);
        },
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SplashView()),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginView(),
          ),
          GoRoute(
            path: '/mainscreen',
            builder: (context, state) => const MainView(),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceView(),
          ),
        ],
      );
}
