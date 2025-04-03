import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../ViewModel/component/spaces_height.dart';
import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';
import '../ViewModel/core/ml/recognition_embedding.dart';
import '../ViewModel/core/ml/recognizer.dart';
import '../ViewModel/providers/attendance_providers.dart';
import '../ViewModel/widget/face_detector_painter.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  List<CameraDescription>? _availableCameras;
  late CameraDescription description = _availableCameras![1];
  CameraController? _controller;
  bool isBusy = false;
  late List<RecognitionEmbedding> recognitions = [];
  late Size size;
  CameraLensDirection camDirec = CameraLensDirection.front;
  bool isFaceRegistered = false;
  String faceStatusMessage = '';

  //TODO declare face detectore
  late FaceDetector detector;

  //TODO declare face recognizer
  late Recognizer recognizer;

  dynamic _scanResults;
  CameraImage? frame;

  img.Image? image;
  bool register = false;

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();

    //TODO initialize face detector
    detector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );

    //TODO initialize face recognizer
    recognizer = Recognizer();

    _initializeCamera();

    getCurrentPosition();
  }

  _initializeCamera() async {
    _availableCameras = await availableCameras();
    _controller = CameraController(description, ResolutionPreset.high);
    await _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      size = _controller!.value.previewSize!;

      _controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });
    });
  }

  doFaceDetectionOnFrame() async {
    //TODO convert frame into InputImage format
    InputImage inputImage = getInputImage();

    //TODO pass InputImage to face detection model and detect faces
    List<Face> faces = await detector.processImage(inputImage);

    for (Face face in faces) {
      print("Face location ${face.boundingBox}");
    }

    //TODO perform face recognition on detected faces
    performFaceRecognition(faces);
  }

  performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
    image = convertYUV420ToImage(frame!);
    image = img.copyRotate(
      image!,
      angle: camDirec == CameraLensDirection.front ? 270 : 90,
    );

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      //TODO crop face
      img.Image croppedFace = img.copyCrop(
        image!,
        x: faceRect.left.toInt(),
        y: faceRect.top.toInt(),
        width: faceRect.width.toInt(),
        height: faceRect.height.toInt(),
      );

      //TODO pass cropped face to face recognition model
      RecognitionEmbedding recognition = recognizer.recognize(
        croppedFace,
        face.boundingBox,
      );

      recognitions.add(recognition);

      // Memeriksa validitas wajah yang dikenali
      bool isValid = await recognizer.isValidFace(recognition.embedding);

      // Perbarui status wajah dan pesan teks berdasarkan hasil pengenalan
      if (isValid) {
        setState(() {
          isFaceRegistered = true;
          faceStatusMessage = 'Wajah sudah terdaftar';
        });
      } else {
        setState(() {
          isFaceRegistered = false;
          faceStatusMessage = 'Wajah belum terdaftar';
        });
      }
    }

    setState(() {
      isBusy = false;
      _scanResults = recognitions;
    });
  }

  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data!.setPixelR(w, h, yuv2rgb(y, u, v)); //= yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(
      frame!.width.toDouble(),
      frame!.height.toDouble(),
    );
    final camera = description;
    final imageRotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );

    final inputImageFormat = InputImageFormatValue.fromRawValue(
      frame!.format.raw,
    );

    final int bytesPerRow =
        frame?.planes.isNotEmpty == true ? frame!.planes.first.bytesPerRow : 0;

    final inputImageMetaData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageMetaData,
    );

    return inputImage;
  }

  void _reverseCamera() async {
    if (camDirec == CameraLensDirection.back) {
      camDirec = CameraLensDirection.front;
      description = _availableCameras![1];
    } else {
      camDirec = CameraLensDirection.back;
      description = _availableCameras![0];
    }
    await _controller!.stopImageStream();
    setState(() {
      _controller;
    });
    // Inisialisasi kamera dengan deskripsi kamera baru
    _initializeCamera();
  }

  // TODO Show rectangles around detected faces
  Widget buildResult() {
    if (_scanResults == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
    }
    final Size imageSize = Size(
      _controller!.value.previewSize!.height,
      _controller!.value.previewSize!.width,
    );
    CustomPainter painter = FaceDetectorPainter(
      imageSize,
      _scanResults,
      camDirec,
    );
    return CustomPaint(painter: painter);
  }

  Future<void> getCurrentPosition() async {
    try {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      locationData = await location.getLocation();
      latitude = locationData.latitude;
      longitude = locationData.longitude;

      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'IO_ERROR') {
        debugPrint(
          'A network error occurred trying to lookup the supplied coordinates: ${e.message}',
        );
      } else {
        debugPrint('Failed to lookup coordinates: ${e.message}');
      }
    } catch (e) {
      debugPrint('An unknown error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              width: size.width,
              height: size.height,
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              width: size.width,
              height: size.height,
              child: buildResult(),
            ),
            Positioned(
              top: 20.0,
              left: 40.0,
              right: 40.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color:
                      isFaceRegistered
                          ? AppColors.primary.withOpacity(0.47)
                          : AppColors.red.withOpacity(0.47),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  faceStatusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 5.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.47),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Absensi Datang',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Kantor',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push(
                                '/location',
                                extra: {
                                  'latitude': latitude,
                                  'longitude': longitude,
                                },
                              );
                            },
                            child: Assets.images.seeLocation.image(
                              height: 30.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpaceHeight(15.h),
                    SpaceHeight(15.h),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _reverseCamera,
                          icon: Assets.icons.reverse.svg(width: 48.0),
                        ),
                        const Spacer(),
                        Consumer<AttendanceProviders>(
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: () {
                                isFaceRegistered
                                    ? value.checkout(
                                      context: context,
                                      lat: latitude.toString(),
                                      long: longitude.toString(),
                                    )
                                    : null;
                              },
                              icon: Icon(
                                Icons.circle,
                                size: 70.sp,
                                color:
                                    isFaceRegistered
                                        ? AppColors.red
                                        : AppColors.grey,
                              ),
                            );
                          },
                        ),
                        // BlocConsumer<
                        //   CheckoutAttendanceBloc,
                        //   CheckoutAttendanceState
                        // >(
                        //   listener: (context, state) {
                        //     state.maybeWhen(
                        //       orElse: () {},
                        //       error: (message) {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           SnackBar(content: Text(message)),
                        //         );
                        //       },
                        //       loaded: (responseModel) {
                        //         context.pushReplacement(
                        //           const AttendanceSuccessPage(
                        //             status: 'Berhasil Checkout',
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   },
                        //   builder: (context, state) {
                        //     return state.maybeWhen(
                        //       orElse: () {
                        //         return IconButton(
                        //           onPressed:
                        //               isFaceRegistered ? _takeAbsen : null,
                        //           icon: const Icon(Icons.circle, size: 70.0),
                        //           color:
                        //               isFaceRegistered
                        //                   ? AppColors.red
                        //                   : AppColors.grey,
                        //         );
                        //       },
                        //       loading:
                        //           () => const Center(
                        //             child: CircularProgressIndicator(),
                        //           ),
                        //     );
                        //   },
                        // ),
                        const Spacer(),
                        SpaceWidth(48.w),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
