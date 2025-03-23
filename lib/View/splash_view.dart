import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../ViewModel/component/spaces_height.dart';
import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () => context.go('/login'));
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
