/// Currently playing playlist screen

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/img/poster.dart';
import 'package:tune/widgets/music/display/playlist_viewer_item.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

import '../../widgets/music/display/audio_player_mini.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);
  static String id = 'Playlist Screen';

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<PlaylistViewerItem> children = [];

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
          onChangeSongList: () {
            setState(() {});
          },
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
              ],
            ),
            Provider.of<ScreenStateTracker>(context).getAudioPlayerMini,
          ],
        ),
      );
    });
  }
}
