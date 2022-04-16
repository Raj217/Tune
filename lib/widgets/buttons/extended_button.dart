import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tune/utils/constants/system_constants.dart';

GestureDetector ExtendedButton(
    {double extendedRadius = 50,
    Color extendedBGColor = Colors.transparent,
    String? iconName,
    double iconHeight = 15,
    Color iconColor = kIconsColor,
    double angle = 0,
    Widget? child,
    void Function()? onTap}) {
  /// Creates a button with extended area so that it will be easier for the
  /// user to tap and use that button

  return GestureDetector(
      child: Transform.rotate(
        alignment: Alignment.center,
        angle: angle,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.circle,
              color: extendedBGColor,
              size: extendedRadius,
            ),
            child ??
                SvgPicture.asset(
                  '$kIconsPath/$iconName.svg',
                  height: iconHeight,
                  color: iconColor,
                ),
          ],
        ),
      ),
      onTap: onTap);
}
