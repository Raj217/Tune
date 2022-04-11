/// Currently playing playlist screen

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tune/utils/constant.dart';
import 'package:tune/widgets/animation/liquid_animation.dart';
import 'package:tune/widgets/img/poster.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);
  static String id = 'Playlist Screen';

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SvgPicture.asset(
                  '$kIconsPath/menu.svg',
                  color: kWhite,
                ),
              ),
              Poster(),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SvgPicture.asset(
                  '$kIconsPath/appOptions.svg',
                  color: kWhite,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: LiquidAnimation(),
          )
        ],
      ),
    );
  }
}
