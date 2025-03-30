import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/constants/asset_key.dart';

class GifWidget extends StatelessWidget {
  final String iconData;
  final double? width;
  final double? height;
  const GifWidget({super.key, required this.iconData, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      '$assetsGif/$iconData.json',
      height: height,
      width: width,
    );
  }
}
