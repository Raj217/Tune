import 'package:flutter/material.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatelessWidget {
  /// Svg file name of the icon (don't include .svg)
  final String iconName;

  final void Function()? onTap;

  final EdgeInsets padding;

  /// Creates a button with an svg asset stored in the default icon storage location
  const CustomIconButton(
      {Key? key,
      required this.iconName,
      this.onTap,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        child: SvgPicture.asset(
          '$kDefaultIconsPath/$iconName.svg',
          color: kIconsColor,
          width: kDefaultIconWidth,
        ),
        onTap: onTap,
      ),
    );
  }
}
