import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locaface/View/check_out_view.dart';
import 'package:locaface/View/check_in_view.dart';
import 'package:locaface/View/location_view.dart';
import 'package:locaface/View/register_face_attendance_page.dart';
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
            path: '/regisFace',
            builder: (context, state) => const RegisterFaceAttendancePage(),
          ),

          GoRoute(
            path: '/checkin',
            builder: (context, state) => const CheckInView(),
          ),
          GoRoute(
            path: '/checkout',
            builder: (context, state) => const CheckOutView(),
          ),
          GoRoute(
            path: '/location',
            builder: (context, state) {
              final extraData = state.extra as Map<String, dynamic>?;
              final lat = extraData?['latitude'] as double?;
              final long = extraData?['longitude'] as double?;
              return LocationView(latitude: lat, longitude: long);
            },
          ),
        ],
      );
}
