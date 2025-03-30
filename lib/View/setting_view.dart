import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locaface/ViewModel/component/spaces_height.dart';
import 'package:locaface/ViewModel/core/constants/colors.dart';
import 'package:locaface/ViewModel/providers/auth_providers.dart';
import 'package:provider/provider.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Setting',
          style: GoogleFonts.kumbhSans(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account',
                style: GoogleFonts.kumbhSans(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
              SpaceHeight(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
              SpaceHeight(14.h),
              Divider(),
              SpaceHeight(17.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Password',
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
              SpaceHeight(14.h),
              Divider(),
              SpaceHeight(20.h),
              Text(
                'Preferences',
                style: GoogleFonts.kumbhSans(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
              SpaceHeight(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
              SpaceHeight(14.h),
              Divider(),
              SpaceHeight(17.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance',
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
              SpaceHeight(14.h),
              Divider(),
              SpaceHeight(20.h),
              Text(
                'Support',
                style: GoogleFonts.kumbhSans(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
              SpaceHeight(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terms of Service &\nPrivacy',
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: AppColors.grey,
                  ),
                ],
              ),
              SpaceHeight(14.h),
              Divider(),
              SpaceHeight(17.h),
              Consumer<AuthProviders>(
                builder: (context, value, child) {
                  return GestureDetector(
                    onTap: () {
                      print('yoh');
                      value.authL(context: context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Logout',
                          style: GoogleFonts.kumbhSans(
                            fontSize: 16.sp,
                            color: AppColors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20.sp,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SpaceHeight(14.h),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
