import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tune/utils/constants/system_constants.dart';

class LiquidAnimation extends StatelessWidget {
  /// Height of base
  final double height;

  const LiquidAnimation({Key? key, this.height = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Lottie.asset(
          '$kDefaultLottieAnimationsPath/wave-flow.json',
        ),
        CustomPaint(
          painter:
              Base(width: MediaQuery.of(context).size.width, height: height),
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
    paint.color = kBaseColor;
    canvas.drawRect(Rect.fromLTWH(0, height / 10, width, height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
