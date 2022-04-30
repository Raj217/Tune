import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/logo/logo_icons.dart';

class TuneLogo extends StatelessWidget {
  final double _logoSize;

  TuneLogo({Key? key, double? logoSize})
      : _logoSize = logoSize ?? AppConstants.sizes.kSplashScreenLogoSize,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GlowIcon(
          // Giving the blur for glow effect
          Logo.logo,
          glowColor:
              AppConstants.colors.tertiaryColors.kTuneLogoBackgroundGlowColor,
          color: Colors.transparent,
          blurRadius: 15,
          size: _logoSize,
        ),
        ShaderMask(
          // The actual logo with linear gradient coloring
          child: SizedBox(
            width: _logoSize * 1.2,
            height: _logoSize * 1.2,
            child: Icon(
              Logo.logo,
              size: _logoSize,
              color: Colors.white,
            ),
          ),
          shaderCallback: (Rect bounds) {
            Rect rect = Rect.fromLTRB(0, 0, _logoSize, _logoSize);
            return LinearGradient(
                    colors: AppConstants
                        .colors.tertiaryColors.kTuneLogoGradientColor,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)
                .createShader(rect);
          },
        ),
      ],
    );
  }
}
