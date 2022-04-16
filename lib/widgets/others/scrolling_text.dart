import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tune/utils/formatter.dart';

import 'package:tune/utils/constants/system_constants.dart';

SizedBox ScrollingText({
  String? text,
  required double width,
  required TextStyle style,
}) {
  return SizedBox(
    width: width,
    child: Center(
      child: TextScroll(
          Formatter.scrollText(width: width, style: style, text: text),
          velocity: kTextAutoScrollVelocity,
          style: style),
    ),
  );
}
