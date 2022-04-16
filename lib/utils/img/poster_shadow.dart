/// Creates Shadow with the custom shape as the poster

import 'package:flutter/material.dart';

import 'package:tune/utils/img/poster_clipper.dart';

class PosterShadow extends CustomPainter {
  /// Height of the poster shadow
  late double _height;

  /// Width of the poster shadow
  late double _width;

  /// Spread Radius of the shadow
  late double _spread;

  /// Color of the shadow
  late Color _color;

  /// Offset of the poster Shadow
  late Offset _offset;
  PosterShadow(
      {required double height,
      required double width,
      required double spread,
      required Color color,
      Offset offset = const Offset(0, 0)}) {
    _height = height;
    _width = width;
    _spread = spread;
    _color = color;
    _offset = offset;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Path shapePath = PosterClipper(
            height: _height, width: _width, offset: _offset, top: _spread)
        .getClip(size);
    canvas.drawShadow(shapePath, _color, _spread, false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
