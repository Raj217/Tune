/// For the normal static necessary conversions and formatting
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
      Size _txtSize = textSize(text, style);
      if (_txtSize.width < width) {
        gap = 0;
      }
      return (text + ' ' * gap);
    } else {
      return ' ';
    }
  }

  static Text stringOverflowHandler({
    String? text,
    TextAlign? textAlign,
    required double width,
    required TextStyle style,
  }) {
    if (text != null) {
      Size _txtSize = textSize(text, style);
      if (_txtSize.width < width) {
        return Text(
          text,
          style: style,
          textAlign: textAlign,
        );
      } else {
        String outText = text[0];
        int ind = 1;
        while (textSize(outText + '...', style).width <= width) {
          outText += text[ind++];
        }
        return Text(
          outText + '...',
          style: style,
          textAlign: textAlign,
        );
      }
    } else {
      return Text(
        ' ',
        style: style,
        textAlign: textAlign,
      );
    }
  }

  static Size textSize(String? text, TextStyle? style) {
    /// Returns the size of the Text widget
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static String extractSongNameFromPath(String filePath) {
    /// Extract the song name from a path string
    List<String> loc = filePath.split('/');
    String songName = loc[loc.length - 1];

    List<String> dots = songName.split('.');

    return songName.substring(0, songName.indexOf(dots[dots.length - 1]) - 1);
  }
}
