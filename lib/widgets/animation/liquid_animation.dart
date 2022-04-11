import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tune/utils/constant.dart';

class LiquidAnimation extends StatelessWidget {
  /// Height of base
  double height;
  LiquidAnimation({Key? key, this.height = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    canvas.drawRect(Rect.fromLTWH(-width / 2, -1, width, height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
