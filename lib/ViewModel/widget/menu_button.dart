import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../component/spaces_height.dart';
import '../core/constants/colors.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;
  const MenuButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: 40.0.w, height: 40.h),
            SpaceHeight(4.h),
            Text(
              label,
              style: GoogleFonts.kumbhSans(
                fontSize: 12.sp,
                color: AppColors.menuText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
