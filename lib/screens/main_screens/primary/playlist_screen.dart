// TODO: Add animations to poster and list view

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/app_constants.dart';

import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/img/poster.dart';
import 'package:tune/widgets/display/playlist_viewer_item.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

import '../../../widgets/display/list_viewer.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);
  static String id = 'Playlist Screen';

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

//TODO: Extract the playlist viewer
class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(builder: (context, handler, _) {
      Size screenSize = MediaQuery.of(context).size;
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
                      showIcons: const [0, 3],
                    ),
                    Provider.of<ScreenStateTracker>(context, listen: false)
                        .getPoster
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                GlowText(
                  handler.getCurrentPlaylistName,
                  style: AppConstants.textStyles.kAudioTitleTextStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                ListViewer(
                  height: screenSize.height * (235 / 756),
                  audios: handler.getCurrentPlaylistMediaItems,
                  currentlyPlaying: handler.getAudioHandler.mediaItem.value,
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
