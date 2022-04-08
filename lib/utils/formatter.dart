import 'package:flutter/material.dart';

class Formatter {
  static String durationFormatted(Duration duration) {
    String out = duration.toString();
    out = out.substring(0, out.indexOf('.'));
    if (duration.inHours <= 0) {
      out = out.substring(out.indexOf(':') + 1);
    }
    return out;
  }

  static String scrollText(
      {String? text,
      required double width,
      required TextStyle style,
      int gap = 13}) {
    if (text != null) {
      Size _txtSize = Formatter.textSize(text, style);
      if (_txtSize.width < width) {
        gap = 0;
      }
      return (text + ' ' * gap);
    } else {
      return ' ';
    }
  }

  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
