import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:tune/utils/formatter.dart';

import 'package:tune/utils/app_constants.dart';

class ScrollingText extends StatelessWidget {
  /// The text to be shown
  final String? text;

  /// Max Width until the scroll starts
  final double width;

  /// Style applied to the text style
  ///
  /// This is necessary to calculate if the text width is more than [width]
  /// so that the scrolling can start
  final TextStyle style;

  /// Velocity of the text with which it is scrolling.
  ///
  /// Defaults to [AppConstants.velocities.kTextAutoScrollVelocity]
  final Velocity _velocity;

  /// Displays the [text] in normal way until its width is less than [width].
  ///
  /// If it's width is more than [width] it starts to scroll automatically
  ScrollingText({
    Key? key,
    this.text,
    required this.width,
    required this.style,
    Velocity? v,
  })  : _velocity = v ?? AppConstants.velocities.kTextAutoScrollVelocity,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(
        child: TextScroll(
            Formatter.scrollText(width: width, style: style, text: text),
            velocity: _velocity,
            style: style),
      ),
    );
  }
}
