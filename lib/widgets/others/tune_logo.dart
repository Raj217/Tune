import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/logo/logo_icons.dart';

class TuneLogo extends StatelessWidget {
  final double logoSize;

  const TuneLogo({Key? key, this.logoSize = kDefaultLogoSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GlowIcon(
          // Giving the blur for glow effect
          Logo.logo,
          glowColor: kTuneLogoBackgroundGlowColor,
          color: Colors.transparent,
          blurRadius: 15,
          size: logoSize,
        ),
        ShaderMask(
          // The actual logo with linear gradient coloring
          child: SizedBox(
            width: logoSize * 1.2,
            height: logoSize * 1.2,
            child: Icon(
              Logo.logo,
              size: logoSize,
              color: Colors.white,
            ),
          ),
          shaderCallback: (Rect bounds) {
            Rect rect = Rect.fromLTRB(0, 0, logoSize, logoSize);
            return const LinearGradient(
                    colors: kTuneLogoGradientColor,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)
                .createShader(rect);
          },
        ),
      ],
    );
  }
}
