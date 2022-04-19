import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tune/utils/constants/system_constants.dart';

class ExtendedButton extends StatelessWidget {
  /// Radius of the circle so that this widget responds to onTap
  double extendedRadius;

  /// Color of the BG, by default [Colors.transparent]
  final Color extendedBGColor;

  /// Svg file name of the icon (don't include .svg)
  final String? svgName;

  double? svgHeight;
  double? svgWidth;

  final String? svgPath;

  final Color svgColor;

  /// Angle of rotation of the Icon
  final double angle;

  /// In case a Svg icon is not used and something else is used
  final Widget? child;

  /// When tapped on the icon or extended region
  final void Function()? onTap;

  /// Creates a button with extended area so that it will be easier for the
  /// user to tap and use that button

  ExtendedButton(
      {Key? key,
      this.extendedRadius = kDefaultExtendedButtonRadius,
      this.extendedBGColor = Colors.transparent,
      this.svgName,
      this.svgPath,
      this.svgHeight,
      this.svgWidth,
      this.svgColor = kIconsColor,
      this.angle = 0,
      this.child,
      this.onTap})
      : assert(svgName != null || svgPath != null || child != null,
            'either of svgName/Path/child must be provided'),
        super(key: key) {
    if (svgHeight == null && svgWidth == null) {
      svgHeight = kDefaultIconHeight;
    }
    if (svgHeight != null && extendedRadius < svgHeight!) {
      extendedRadius = svgHeight! + 10;
    } else if (svgWidth != null && extendedRadius < svgWidth!) {
      extendedRadius = svgWidth! + 10;
    }
  }

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
                    svgPath ?? '$kDefaultIconsPath/$svgName.svg',
                    height: svgHeight,
                    width: svgWidth,
                    color: svgPath == null ? svgColor : null,
                  ),
            ],
          ),
        ),
        onTap: onTap);
  }
}
