import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tune/utils/app_constants.dart';

class ExtendedButton extends StatelessWidget {
  /// Radius of the circle so that this widget responds to onTap
  final double _extendedRadius;

  /// Color of the BG, by default [Colors.transparent]
  final Color extendedBGColor;

  /// Precedence : svgPath > svgName > icon > child
  final IconData? icon;

  /// Svg file name of the icon
  ///
  ///  Precedence : svgPath > svgName > icon > child
  final icons? svgName;

  /// Precedence: width > height
  double? height;

  /// Precedence: width > height
  double? width;

  /// If svgPath is provided the original color of the svg will be used
  ///
  ///  Precedence : svgPath > svgName > icon > child
  final String? svgPath;

  final Color _color;

  /// Angle of rotation of the Icon
  final double angle;

  /// In case a Svg icon is not used and something else is used
  ///
  /// Precedence : svgPath > svgName > icon > child
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
      this.icon,
      this.height,
      this.width,
      Color? color,
      this.angle = 0,
      this.child,
      this.onTap,
      BorderRadius? borderRadius,
      this.takeDefaultAsWidth = false})
      : assert(
            svgName != null || svgPath != null || child != null || icon != null,
            'either svgName/Path/child/icon must be provided'),
        _extendedRadius =
            extendedRadius ?? AppConstants.sizes.kDefaultExtendedButtonRadius,
        _color = color ?? AppConstants.colors.tertiaryColors.kDefaultIconsColor,
        super(key: key) {
    if (height == null && width == null) {
      if (takeDefaultAsWidth == false) {
        height = AppConstants.sizes.kDefaultIconHeight;
      } else {
        width = AppConstants.sizes.kDefaultIconWidth;
      }
    }
    if (height != null && _extendedRadius < height!) {
      extendedRadius = height! + 10;
    } else if (width != null && _extendedRadius < width!) {
      extendedRadius = width! + 10;
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
                  (icon != null
                      ? Icon(icon, size: width ?? height, color: _color)
                      : SvgPicture.asset(
                          svgPath ?? AppConstants.paths.kIconPaths[svgName]!,
                          height: height,
                          width: width,
                          color: svgPath == null ? _color : null,
                        ))
            ],
          ),
        ),
        onTap: onTap);
  }
}
