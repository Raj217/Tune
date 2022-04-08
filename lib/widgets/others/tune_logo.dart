import 'package:flutter/material.dart';
import 'package:tune/utils/constant.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tune/utils/logo/logo_icons.dart';

class TuneLogo extends StatelessWidget {
  TuneLogo({Key? key, this.logoSize = kDefaultLogoSize}) : super(key: key);
  double logoSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GlowIcon(
          // Giving the blur for glow effect
          Logo.logo,
          glowColor: kGreen,
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
                    colors: [kGreen, kDeepYellow],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)
                .createShader(rect);
          },
        ),
      ],
    );
  }
}
