import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locaface/ViewModel/routes/app_route.dart';

class InitialApp extends StatefulWidget {
  const InitialApp({super.key});

  @override
  State<InitialApp> createState() => _InitialAppState();
}

class _InitialAppState extends State<InitialApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoute().router,
        );
      },
    );
  }
}
