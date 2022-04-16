import 'package:flutter/material.dart';

class VerticalScroll extends StatelessWidget {
  final Widget child;
  final Size screenSize;

  const VerticalScroll(
      {Key? key, required this.child, required this.screenSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: screenSize.height * 0.955 - 200 / 3.4),
          child: child,
        ),
      ),
    );
  }
}
