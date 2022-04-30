import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:tune/utils/app_constants.dart';

class LiquidAnimation extends StatelessWidget {
  /// Height of base
  final double _height;

  LiquidAnimation({Key? key, double? height})
      : _height = height ?? AppConstants.sizes.kDefaultMiniAudioBaseHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Lottie.asset(
          AppConstants.paths.kLottieAnimationPaths[animations.waveFlow]!,
        ),
        CustomPaint(
          painter:
              Base(width: MediaQuery.of(context).size.width, height: _height),
        )
      ],
    );
  }
}

class Base extends CustomPainter {
  double width;
  double height;
  Base({required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = AppConstants.colors.secondaryColors.kBaseColor;
    canvas.drawRect(Rect.fromLTWH(0, height / 4, width, height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
