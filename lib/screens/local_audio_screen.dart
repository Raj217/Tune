/// Locally stored audio files tracking here

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/provider/music/music_handler_admin.dart';
import 'package:tune/widgets/music/audio_player_mini.dart';

import '../utils/constant.dart';
import '../utils/storage/file_handler.dart';

class LocalAudioScreen extends StatefulWidget {
  const LocalAudioScreen({Key? key}) : super(key: key);
  static String id = 'Local Audio Screen';

  @override
  State<LocalAudioScreen> createState() => _LocalAudioScreenState();
}

class _LocalAudioScreenState extends State<LocalAudioScreen> {
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
    return Consumer<MusicHandlerAdmin>(builder: (context, handler, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  '$kIconsPath/menu.svg',
                  color: kWhite,
                  width: kDefaultIconWidth,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      '$kIconsPath/search.svg',
                      color: kWhite,
                      height: kDefaultIconHeight,
                    ),
                    const SizedBox(width: 15),
                    SvgPicture.asset(
                      '$kIconsPath/appOptions.svg',
                      color: kWhite,
                      width: kDefaultIconWidth,
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  FileHandler.pick().then((filePath) {
                    handler.initAudioHandler(filePath!);
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
              AudioPlayerMini(),
            ],
          )
        ],
      );
    });
  }
}
