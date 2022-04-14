import 'package:flutter/material.dart';

class VerticalScroll extends StatelessWidget {
  VerticalScroll({Key? key, required this.child, required this.screenSize})
      : super(key: key);
  Widget child;
  Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: screenSize.height * 0.955 - 200 / 3.4),
        child: child,
      ),
    );
  }
}
