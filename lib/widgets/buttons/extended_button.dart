import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tune/utils/constants/system_constants.dart';

class ExtendedButton extends StatelessWidget {
  /// Radius of the circle so that this widget responds to onTap
  final double extendedRadius;

  /// Color of the BG, by default [Colors.transparent]
  final Color extendedBGColor;

  /// Svg file name of the icon (don't include .svg)
  final String? svgName;

  final double svgHeight;

  final Color svgColor;

  /// Angle of rotation of the Icon
  final double angle;

  /// In case a Svg icon is not used and something else is used
  final Widget? child;

  /// When tapped on the icon or extended region
  final void Function()? onTap;

  /// Creates a button with extended area so that it will be easier for the
  /// user to tap and use that button

  const ExtendedButton(
      {Key? key,
      this.extendedRadius = kDefaultExtendedButtonRadius,
      this.extendedBGColor = Colors.transparent,
      this.svgName,
      this.svgHeight = kDefaultIconHeight,
      this.svgColor = kIconsColor,
      this.angle = 0,
      this.child,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    '$kDefaultIconsPath/$svgName.svg',
                    height: svgHeight,
                    color: svgColor,
                  ),
            ],
          ),
        ),
        onTap: onTap);
  }
}
