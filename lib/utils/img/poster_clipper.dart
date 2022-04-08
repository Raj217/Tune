/// Crop the image poster in the custom shape
/// The Shape of the poster is stored and used everywhere, any change here will
/// be reflected everywhere

import 'package:flutter/material.dart';
import 'dart:math';

class PosterClipper extends CustomClipper<Path> {
  late double _height; // Height of the poster
  late double _width; // width of the poster
  late Offset _offset; // Offset of the poster
  late double
      _top; // Top coordinate of the poster (Useful in draw shadow in PosterShadow)
  PosterClipper(
      {required double height,
      required double width,
      Offset offset = const Offset(0, 0),
      double top = 0}) {
    _height = height;
    _width = width;
    _offset = offset;
    _top = top;
  }

  @override
  Path getClip(Size size) {
    final Rect circleBound = Rect.fromCircle(
        center: Offset(
            size.width / 2 + _offset.dx, _height - _width / 2 + _offset.dy),
        radius: _width / 2);
    return Path()
      ..moveTo(size.width / 2 - _width / 2 + _offset.dx, -_top)
      ..lineTo(size.width / 2 - _width / 2 + _offset.dx,
          _height - _width / 2 + _offset.dy)
      ..arcTo(circleBound, pi, -pi, false)
      ..lineTo(size.width / 2 + _width / 2 + _offset.dx, -_top)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
