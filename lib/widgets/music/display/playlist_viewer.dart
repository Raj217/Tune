import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/constants/system_constants.dart';
import '../../../utils/provider/music/audio_handler_admin.dart';
import 'playlist_viewer_item.dart';

class PlaylistViewer extends StatefulWidget {
  final int initIndex;
  const PlaylistViewer({Key? key, required this.initIndex}) : super(key: key);

  @override
  State<PlaylistViewer> createState() => _PlaylistViewerState();
}

class _PlaylistViewerState extends State<PlaylistViewer> {
  List<PlaylistViewerItem> children = [];
  late Timer timer;
  late int prevIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prevIndex = widget.initIndex;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  void changeIndex(int newIndex) {
    setState(() {
      children[newIndex].setColor = kBaseColor;
      children[prevIndex].setColor = kInactiveColor;
      prevIndex = newIndex;
    });
  }

  void addChildren() {
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
    addChildren();
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height * (270 / 756),
      child: ListView(
        children: children,
      ),
    );
  }
}

/*
ListView.builder(
itemCount: nAudio,
itemBuilder: (context, index) {
return PlaylistViewerItem(
index: index,
currentlyPlaying: index == currentlyPlayingIndex.value);
}),
*/
