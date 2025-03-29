import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:locaface/ViewModel/providers/auth_providers.dart';
import 'package:provider/provider.dart';

import '../ViewModel/component/button.dart';
import '../ViewModel/component/custom_text_field.dart';
import '../ViewModel/component/spaces_height.dart';
import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _toggleVisibility = true;
  bool isValidEmail = false;
  bool isOnchange = false;
  bool isOnchangePassword = false;
  bool isValidPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            keyboardType: TextInputType.emailAddress,
            showLabel: false,
            controller: emailController,
            label: 'Email Address',
            color: AppColors.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.icons.email.svg(),
            ),
            onChanged: (value) {
              setState(() {
                isValidEmail = false;
                isOnchange = true;
              });
              RegExp regex = RegExp(
                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
              );
              bool isEmailValid = regex.hasMatch(value);
              if (isEmailValid) {
                setState(() {
                  isValidEmail = true;
                });
              }
            },
            validator: (value) {
              if (value!.isEmpty && isOnchange) {
                return 'Harus diisi';
              }
              if (!isValidEmail && isOnchange) {
                return 'Format email salah';
              }
            },
          ),
          SpaceHeight(18.h),
          CustomTextField(
            showLabel: false,
            controller: passwordController,
            label: 'Password',
            color: AppColors.white,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                Assets.icons.password.path,
                height: 20,
                width: 20,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _toggleVisibility = !_toggleVisibility;
                });
              },
              icon:
                  _toggleVisibility
                      ? const Icon(
                        Icons.visibility_off,
                        color: AppColors.secondGrey,
                      )
                      : const Icon(
                        Icons.visibility,
                        color: AppColors.secondGrey,
                      ),
            ),
            obscureText: _toggleVisibility,
            validator: (value) {
              if (value!.isEmpty && isOnchangePassword) {
                return 'Harus diisi';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  isValidPassword = false;
                });
                return;
              }
              setState(() {
                isValidPassword = true;
                isOnchangePassword = true;
              });
            },
          ),
          SpaceHeight(80.h),
          Consumer<AuthProviders>(
            builder: (context, value, child) {
              return Button.filled(
                onPressed: () async {
                  print('ini');
                  // context.go('/mainscreen');
                  value.login(
                    context: context,
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                },
                label: 'Sign In',
              );
            },
          ),
        ],
      ),
    );
  }
}
