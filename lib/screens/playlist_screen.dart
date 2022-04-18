/// Currently playing playlist screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/widgets/img/poster.dart';
import 'package:tune/widgets/music/display/audio_player_mini.dart';
import 'package:tune/widgets/music/display/playlist_viewer.dart';
import 'package:tune/widgets/overflow_handlers/vertical_scroll.dart';
import 'package:tune/widgets/buttons/icon_button.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);
  static String id = 'Playlist Screen';

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
    lockPortraitMode();
    setBottomNavBarColor(kBaseCounterColor);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<AudioHandlerAdmin>(builder: (context, handler, _) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        body: VerticalScroll(
          screenSize: screenSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      const CustomIconButton(
                          iconName: 'menu',
                          padding: EdgeInsets.only(top: 15, left: 10)),
                      const Poster(),
                      CustomIconButton(
                          iconName: 'appOptions',
                          padding: EdgeInsets.only(
                              top: 15,
                              left: screenSize.width - kDefaultIconWidth - 10)),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const PlaylistViewer(),
                ],
              ),
              AudioPlayerMini()
            ],
          ),
        ),
      );
    });
  }
}
