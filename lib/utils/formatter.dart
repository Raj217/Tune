import 'package:flutter/material.dart';

class Formatter {
  static String durationFormatted(Duration duration) {
    /// Formats Duration to hh:mm:ss and if H == 0,
    /// mm:ss
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
    /// Adds Gap to the text
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
    /// Returns the size of the Text widget
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static String stringOverflowHandler(String text, int maxLength) {
    if (text.length > maxLength) {
      text = text.substring(0, maxLength - 3) + '...';
    }
    return text;
  }

  static String extractSongNameFromPath(String filePath) {
    List<String> loc = filePath.split('/');
    String songName = loc[loc.length - 1];

    List<String> dots = songName.split('.');

    return songName.substring(0, songName.indexOf(dots[dots.length - 1]) - 1);
  }
}
