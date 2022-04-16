import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tune/utils/formatter.dart';

import 'package:tune/utils/constants/system_constants.dart';

class ScrollingText extends StatelessWidget {
  final String? text;
  final double width;
  final TextStyle style;
  const ScrollingText({
    Key? key,
    this.text,
    required this.width,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
