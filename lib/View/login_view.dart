import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../ViewModel/component/button.dart';
import '../ViewModel/component/custom_text_field.dart';
import '../ViewModel/component/spaces_height.dart';
import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(85.0),
            child: Assets.images.logo.image(),
          ),
          SpaceHeight(30.h),
          CustomTextField(
            showLabel: false,
            controller: emailController,
            label: 'Email Address',
            color: AppColors.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.icons.email.svg(),
            ),
          ),
          SpaceHeight(18.h),
          CustomTextField(
            showLabel: false,
            controller: passwordController,
            label: 'Password',
            color: AppColors.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.icons.password.svg(),
            ),
            obscureText: true,
          ),
          SpaceHeight(80.h),
          Button.filled(
            onPressed: () {
              context.go('/mainscreen');
            },
            label: 'Sign In',
          ),
        ],
      ),
    );
  }
}
