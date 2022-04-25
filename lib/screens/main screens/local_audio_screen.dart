/// Locally stored audio_related files tracking here

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/music/display/audio_player_mini.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/utils/storage/file_handler.dart';

class LocalAudioScreen extends StatefulWidget {
  const LocalAudioScreen({Key? key}) : super(key: key);
  static String id = 'Local Audio Screen';

  @override
  State<LocalAudioScreen> createState() => _LocalAudioScreenState();
}

class _LocalAudioScreenState extends State<LocalAudioScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return VerticalScroll(
      screenSize: screenSize,
      child: Consumer<AudioHandlerAdmin>(builder: (context, handler, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAppBar(),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: screenSize.width - screenSize.height * 0.07 - 5),
                  child: GestureDetector(
                    onTap: () async {
                      FileHandler.pick().then((filePaths) async {
                        String? songName;
                        if (filePaths != null) {
                          for (String? path in filePaths) {
                            if (path != null) {
                              songName =
                                  Formatter.extractSongNameFromPath(path);
                              handler
                                  .addAudio(path: path)
                                  .then((value) => setState(() {
                                        Provider.of<ScreenStateTracker>(context,
                                                    listen: false)
                                                .setAudioPlayerMini =
                                            AudioPlayerMini(
                                          songName: songName,
                                          visible: true,
                                        );
                                      }));
                            }
                          }
                        }
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: kBaseColor,
                          size: screenSize.height * 0.07,
                        ),
                        Icon(
                          Icons.add,
                          color: kBackgroundColor,
                          size: screenSize.height * 0.03,
                        )
                      ],
                    ),
                  ),
                ),
                Provider.of<ScreenStateTracker>(context).getAudioPlayerMini,
              ],
            ),
          ],
        );
      }),
    );
  }
}
