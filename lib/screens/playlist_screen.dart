/// Currently playing playlist screen

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tune/utils/constant.dart';
import 'package:tune/widgets/img/poster.dart';
import 'package:tune/widgets/music/audio_player_mini.dart';
import 'package:tune/widgets/others/vertical_scroll.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);
  static String id = 'Playlist Screen';

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lockPortraitMode();
    setBottomNavBarColor(kBaseCounterColor);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: VerticalScroll(
        screenSize: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10),
                  child: SvgPicture.asset(
                    '$kIconsPath/menu.svg',
                    color: kWhite,
                    width: kDefaultIconWidth,
                  ),
                ),
                Poster(),
                Padding(
                  padding: EdgeInsets.only(
                      top: 15, left: screenSize.width - kDefaultIconWidth - 10),
                  child: SvgPicture.asset(
                    '$kIconsPath/appOptions.svg',
                    color: kWhite,
                    width: kDefaultIconWidth,
                  ),
                ),
              ],
            ),
            AudioPlayerMini()
          ],
        ),
      ),
    );
  }
}
