import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ViewModel/component/spaces_height.dart';
import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';
import '../ViewModel/providers/auth_providers.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Timer _checkLoginTimeOut;

  @override
  void initState() {
    _checkLoginTimeOut = Timer(
      const Duration(seconds: 3),
      () => _checkLogin(context),
    );
    super.initState();
  }

  @override
  void dispose() {
    _checkLoginTimeOut.cancel();
    super.dispose();
  }

  Future<bool?> _checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email =
        prefs.getString(
          'user'
          'email',
        ) ??
        '';
    String password =
        prefs.getString(
          'user'
          'password',
        ) ??
        '';
    if (_checkLoginTimeOut.isActive) {
      await Future.delayed(const Duration(seconds: 1));
      AuthProviders authProvider = Provider.of(context, listen: false);
      final isLogin = await authProvider.checkLogin();
      if (isLogin == true) {
        final authProvider = Provider.of<AuthProviders>(context, listen: false);
        await authProvider.login(
          email: email,
          password: password,
          context: context,
        );
      } else {
        context.go('/login');
      }
      _checkLoginTimeOut.cancel();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin(context);
    });
    // Future.delayed(const Duration(seconds: 2), () => context.go('/login'));
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Assets.images.logo.image(),
          ),
          const Spacer(),
          Assets.images.company.image(height: 85.h),
          SpaceHeight(20.w),
        ],
      ),
    );
  }
}
