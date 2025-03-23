import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:locaface/ViewModel/core/extensions/build_context_ext.dart';

import '../ViewModel/component/spaces_height.dart';
import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  List<CameraDescription>? _availableCameras;
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _initializeCamera() async {
    _availableCameras = await availableCameras();
    _initCamera(_availableCameras!.first);
  }

  void _initCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.max);
    await _controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _takePicture() async {
    await _controller!.takePicture();
    if (mounted) {
      // context.pushReplacement(const AttendanceSuccessPage());
    }
  }

  void _reverseCamera() {
    final lensDirection = _controller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras!.firstWhere(
        (description) => description.lensDirection == CameraLensDirection.back,
      );
    } else {
      newDescription = _availableCameras!.firstWhere(
        (description) => description.lensDirection == CameraLensDirection.front,
      );
    }
    _initCamera(newDescription);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: context.deviceWidth / context.deviceHeight,
            child: CameraPreview(_controller!),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   padding: EdgeInsets.all(16.0),
                //   decoration: BoxDecoration(
                //     color: AppColors.primary.withOpacity(0.47),
                //     borderRadius: BorderRadius.circular(10.r),
                //   ),
                // ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _reverseCamera,
                      icon: Assets.icons.reverse.svg(width: 48.w),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _takePicture,
                      icon: Icon(Icons.circle, size: 70.sp),
                      color: AppColors.red,
                    ),
                    const Spacer(),
                    SpaceWidth(48.w),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
