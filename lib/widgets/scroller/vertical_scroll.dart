/// Used to create a vertical scrolling view soo that in case the phone size is
/// too small the app contents are scrollable
/// NOTE: It also includes the safe area

import 'package:flutter/material.dart';
import 'package:tune/utils/app_constants.dart';

class VerticalScroll extends StatelessWidget {
  final Widget child;
  final Size screenSize;
  final Color _backgroundColor;

  VerticalScroll(
      {Key? key,
      required this.child,
      required this.screenSize,
      Color? backgroundColor})
      : _backgroundColor = backgroundColor ??
            AppConstants.colors.secondaryColors.kBackgroundColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: screenSize.height * 0.955 - 200 / 3.4),
            child: child,
          ),
        ),
      ),
    );
  }
}
