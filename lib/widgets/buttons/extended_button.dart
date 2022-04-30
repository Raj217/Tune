import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tune/utils/app_constants.dart';

class ExtendedButton extends StatelessWidget {
  /// Radius of the circle so that this widget responds to onTap
  final double _extendedRadius;

  /// Color of the BG, by default [Colors.transparent]
  final Color extendedBGColor;

  /// Svg file name of the icon
  final icons? svgName;

  double? svgHeight;
  double? svgWidth;

  final String? svgPath;

  final Color _svgColor;

  /// Angle of rotation of the Icon
  final double angle;

  /// In case a Svg icon is not used and something else is used
  final Widget? child;

  /// When tapped on the icon or extended region
  final void Function()? onTap;

  /// If this is false (default) the svgHeight will be considered else svgWidth
  /// will be considered in case both svgHeight and svgWidth are null
  final bool takeDefaultAsWidth;

  /// Creates a button with extended area so that it will be easier for the
  /// user to tap and use that button

  ExtendedButton(
      {Key? key,
      double? extendedRadius,
      this.extendedBGColor = Colors.transparent,
      this.svgName,
      this.svgPath,
      this.svgHeight,
      this.svgWidth,
      Color? svgColor,
      this.angle = 0,
      this.child,
      this.onTap,
      this.takeDefaultAsWidth = false})
      : assert(svgName != null || svgPath != null || child != null,
            'either svgName/Path/child must be provided'),
        _extendedRadius =
            extendedRadius ?? AppConstants.sizes.kDefaultExtendedButtonRadius,
        _svgColor =
            svgColor ?? AppConstants.colors.tertiaryColors.kDefaultIconsColor,
        super(key: key) {
    if (svgHeight == null && svgWidth == null) {
      if (takeDefaultAsWidth == false) {
        svgHeight = AppConstants.sizes.kDefaultIconHeight;
      } else {
        svgWidth = AppConstants.sizes.kDefaultIconWidth;
      }
    }
    if (svgHeight != null && _extendedRadius < svgHeight!) {
      extendedRadius = svgHeight! + 10;
    } else if (svgWidth != null && _extendedRadius < svgWidth!) {
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
                size: _extendedRadius,
              ),
              child ??
                  SvgPicture.asset(
                    svgPath ?? AppConstants.paths.kIconPaths[svgName]!,
                    height: svgHeight,
                    width: svgWidth,
                    color: svgPath == null ? _svgColor : null,
                  ),
            ],
          ),
        ),
        onTap: onTap);
  }
}
