import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locaface/Model/auth_model.dart';
import 'package:locaface/ViewModel/core/extensions/date_time_ext.dart';
import 'package:locaface/ViewModel/providers/auth_providers.dart';
import 'package:locaface/ViewModel/shared/user_preferences.dart';
import 'package:provider/provider.dart';

import '../ViewModel/component/button.dart';
import '../ViewModel/component/spaces_height.dart';
import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';
import '../ViewModel/widget/menu_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? faceEmbedding;
  @override
  void initState() {
    _initializeFaceEmbedding();
    super.initState();
  }

  Future<void> _initializeFaceEmbedding() async {
    try {
      final authData = await UserPreferences().getUserModel();
      setState(() {
        faceEmbedding = authData?.user?.faceEmbedding;
      });
    } catch (e) {
      // Tangani error di sini jika ada masalah dalam mendapatkan authData
      print('Error fetching auth data: $e');
      setState(() {
        faceEmbedding = null; // Atur faceEmbedding ke null jika ada kesalahan
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProviders>(context);
    // AuthModel user = auth.auth;
    // print('Face Embedding : ${user.user!.faceEmbedding}');
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(
                      'https://i.pinimg.com/originals/1b/14/53/1b14536a5f7e70664550df4ccaa5b231.jpg',
                      width: 48.w,
                      height: 48.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SpaceWidth(12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Chopper Sensei',
                        style: GoogleFonts.kumbhSans(
                          fontSize: 18.sp,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Doctor',
                        style: GoogleFonts.kumbhSans(
                          fontSize: 14.sp,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SpaceHeight(24.h),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondGrey),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  children: [
                    Text(
                      DateTime.now().toFormattedTime(),
                      style: GoogleFonts.kumbhSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      DateTime.now().toFormattedDate(),
                      style: GoogleFonts.kumbhSans(
                        color: AppColors.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                    SpaceHeight(16.h),
                    const Divider(),
                    SpaceHeight(16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Presence',
                              style: GoogleFonts.kumbhSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey,
                              ),
                            ),
                            SpaceHeight(16.h),
                            Text(
                              DateTime.now().toFormattedTime(),
                              style: GoogleFonts.kumbhSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Leave',
                              style: GoogleFonts.kumbhSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey,
                              ),
                            ),
                            SpaceHeight(16.h),
                            Text(
                              '--:--:--',
                              style: GoogleFonts.kumbhSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SpaceHeight(24.h),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height,
                ),
                child: GridView(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 30.0,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MenuButton(
                      label: 'Presence',
                      iconPath: Assets.icons.menu.datang.path,
                      onPressed: () {},
                    ),
                    MenuButton(
                      label: 'Leave',
                      iconPath: Assets.icons.menu.pulang.path,
                      onPressed: () {},
                    ),
                    MenuButton(
                      label: 'Permit',
                      iconPath: Assets.icons.menu.izin.path,
                      onPressed: () {},
                    ),
                    MenuButton(
                      label: 'Notes',
                      iconPath: Assets.icons.menu.catatan.path,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SpaceHeight(24.h),
              faceEmbedding != null
                  ? Button.filled(
                    onPressed: () {
                      print('Nice');
                      // context.push(const SettingPage());
                    },
                    label: 'Attendance Using Face ID',
                    textColor: AppColors.white,
                    icon: Assets.icons.attendance.svg(),
                    color: AppColors.primary,
                  )
                  : Button.filled(
                    onPressed: () {
                      showBottomSheet(
                        backgroundColor: AppColors.white,
                        context: context,
                        builder:
                            (context) => Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.r),
                                  topRight: Radius.circular(24.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54, // shadow color
                                    blurRadius: 20, // shadow radius
                                    offset: Offset(5, 10), // shadow offset
                                    spreadRadius:
                                        0.1, // The amount the box should be inflated prior to applying the blur
                                    blurStyle:
                                        BlurStyle.normal, // set blur style
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 66.w,
                                      height: 8.h,
                                      child: Divider(
                                        color: AppColors.secondGrey,
                                      ),
                                    ),
                                  ),
                                  const CloseButton(),
                                  Center(
                                    child: Text(
                                      'Oops !',
                                      style: GoogleFonts.kumbhSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  SpaceHeight(4.h),
                                  Center(
                                    child: Text(
                                      'The application wants to access the Camera',
                                      style: GoogleFonts.kumbhSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  SpaceHeight(36.h),
                                  Button.filled(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    label: 'Reject',
                                    textColor: AppColors.white,
                                    fontSize: 18.sp,
                                    color: AppColors.secondary,
                                  ),
                                  SpaceHeight(16.h),
                                  Button.filled(
                                    onPressed: () {
                                      context.pop();
                                      context.push('/regisFace');
                                    },
                                    label: 'Allow',
                                    textColor: AppColors.white,
                                    fontSize: 18.sp,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                      );
                    },
                    label: 'Attendance Using Face ID',
                    textColor: AppColors.white,
                    color: AppColors.red,
                    icon: Assets.icons.attendance.svg(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
