/// Locally stored audio files tracking here

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/screens/menu_screen.dart';
import 'package:tune/widgets/music/display/audio_player_mini.dart';
import 'package:tune/widgets/overflow_handlers/vertical_scroll.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/utils/storage/file_handler.dart';
import 'package:tune/widgets/buttons/icon_button.dart';

import '../widgets/scroller/value_scroller.dart';

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
                      await FileHandler.pick().then((String? filePath) async {
                        String? songName;
                        if (filePath != null) {
                          songName =
                              Formatter.extractSongNameFromPath(filePath);
                          await handler
                              .addAudio(path: filePath)
                              .then((value) => setState(() {
                                    Provider.of<ScreenStateTracker>(context,
                                            listen: false)
                                        .setAudioPlayerMini = AudioPlayerMini(
                                      songName: songName,
                                      visible: true,
                                    );
                                  }));
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
