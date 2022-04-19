/// Currently playing playlist screen

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/img/poster.dart';
import 'package:tune/widgets/music/display/audio_player_mini.dart';
import 'package:tune/widgets/music/display/playlist_viewer.dart';
import 'package:tune/widgets/music/display/playlist_viewer_item.dart';
import 'package:tune/widgets/overflow_handlers/vertical_scroll.dart';
import 'package:tune/widgets/buttons/icon_button.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);
  static String id = 'Playlist Screen';

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Timer? timer;
  List<PlaylistViewerItem> children = [];
  late int prevIndex;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      prevIndex = Provider.of<AudioHandlerAdmin>(context, listen: false)
          .getCurrentlyPlayingAudioIndex;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          addChildren();
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  void addChildren() {
    children = [];
    for (int i = 0;
        i <
            Provider.of<AudioHandlerAdmin>(context, listen: false)
                .getNAudioValueNotifier;
        i++) {
      children.add(
        PlaylistViewerItem(
          index: i,
          currentlyPlaying: i ==
              Provider.of<AudioHandlerAdmin>(context, listen: false)
                  .getCurrentlyPlayingAudioIndex,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(builder: (context, handler, _) {
      Size screenSize = MediaQuery.of(context).size;
      addChildren();
      return VerticalScroll(
        screenSize: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    CustomAppBar(
                      showIcons: const [0, 2],
                    ),
                    const Poster()
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: screenSize.height * (270 / 756),
                  child: ListView(
                    children: children,
                  ),
                ),
                Provider.of<ScreenStateTracker>(context).getAudioPlayerMini,
              ],
            ),
          ],
        ),
      );
    });
  }
}
