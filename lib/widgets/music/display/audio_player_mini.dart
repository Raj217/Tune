import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/animation/audio_visualizer.dart';
import 'package:tune/widgets/animation/liquid_animation.dart';
import 'package:tune/widgets/music/progress/circular_progress_mini.dart';
import '../../../screens/main_screens/secondary/audio_player_screen.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/scroller/scrolling_text.dart';

class AudioPlayerMini extends StatefulWidget {
  /// Base Height is for the empty space for the audio_related name and some basic functions and animation
  double _baseHeight;

  /// Name of the song
  String? songName;

  /// Width of the text scroll area
  double? textScrollWidth;

  AudioPlayerMini(
      {Key? key,
      double? baseHeight,
      this.songName = 'Untitled Song',
      this.textScrollWidth})
      : _baseHeight =
            baseHeight ?? AppConstants.sizes.kDefaultMiniAudioBaseHeight,
        super(key: key);

  set setBaseHeight(double bH) => _baseHeight = bH;
  set setSongName(String sN) => songName = sN;
  set setTextScrollWidth(double tSW) => textScrollWidth = tSW;

  @override
  State<AudioPlayerMini> createState() => _AudioPlayerMiniState();
}

class _AudioPlayerMiniState extends State<AudioPlayerMini>
    with TickerProviderStateMixin {
  /// Width of the text after which text scrolls automatically
  late double textScrollWidth;

  @override
  Widget build(BuildContext context) {
    textScrollWidth =
        widget.textScrollWidth ?? (MediaQuery.of(context).size.width / 1.6);
    return Stack(
      children: [
        LiquidAnimation(),
        Consumer<AudioHandlerAdmin>(builder: (context, handler, _) {
          return Visibility(
            visible: handler.getNumberOfAudios > 0 ? true : false,
            child: Padding(
              padding: EdgeInsets.only(top: widget._baseHeight / 3.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ExtendedButton(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const AudioPlayerScreen();
                      })).then((value) {
                        AppConstants.systemConfigs.setBottomNavBarColor(
                            AppConstants
                                .colors.secondaryColors.kBaseCounterColor);
                      });
                    },
                    svgName: icons.arrow,
                    angle: pi,
                    extendedRadius: 40,
                    svgColor:
                        AppConstants.colors.secondaryColors.kBackgroundColor,
                    svgHeight: AppConstants.sizes.kDefaultIconHeight / 1.2,
                  ),
                  ScrollingText(
                    text: handler.getTitle == 'Untitled Song'
                        ? widget.songName
                        : handler.getTitle,
                    width: textScrollWidth,
                    style:
                        AppConstants.textStyles.kAudioPlayerMiniTitleTextStyle,
                  ),
                  const AudioVisualizer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IntrinsicHeight(
                        child:
                            CircularProgressMini(max: handler.getTotalDuration),
                      ),
                      ExtendedButton(
                        extendedRadius: 42,
                        svgName:
                            handler.getIsPlaying ? icons.pause : icons.play,
                        svgHeight: 18,
                        svgColor: AppConstants
                            .colors.secondaryColors.kBackgroundColor,
                        onTap: handler.getIsPlaying
                            ? () => handler.getAudioHandler.pause()
                            : () => handler.getAudioHandler.play(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
