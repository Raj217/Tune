import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/animation/audio_visualizer.dart';
import 'package:tune/widgets/animation/liquid_animation.dart';
import 'package:tune/widgets/music_progress/circular_progress_mini.dart';
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
  late AnimationController _lottiePlayPauseController;
  bool isPlaying = false;

  @override
  void initState() {
    _lottiePlayPauseController = AnimationController(vsync: this)
      ..addListener(() {
        if (_lottiePlayPauseController.value >= 0.52) {
          if (!Provider.of<AudioHandlerAdmin>(context, listen: false)
                  .getIsPlaying ==
              true) {
            _lottiePlayPauseController.animateTo(0.52);
          } else {
            _lottiePlayPauseController.animateTo(0.1);
          }
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _lottiePlayPauseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textScrollWidth =
        widget.textScrollWidth ?? (MediaQuery.of(context).size.width / 1.6);
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dy < 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const AudioPlayerScreen();
          })).then((value) {
            AppConstants.systemConfigs.setBottomNavBarColor(
                AppConstants.colors.secondaryColors.kBaseCounterColor);
          });
        }
      },
      child: Stack(
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
                      color:
                          AppConstants.colors.secondaryColors.kBackgroundColor,
                      height: AppConstants.sizes.kDefaultIconHeight / 1.2,
                    ),
                    ScrollingText(
                      text: handler.getTitle == 'Untitled Song'
                          ? widget.songName
                          : handler.getTitle,
                      width: textScrollWidth,
                      style: AppConstants
                          .textStyles.kAudioPlayerMiniTitleTextStyle,
                    ),
                    const AudioVisualizer(),
                    StreamBuilder<bool>(
                        stream: handler.getAudioHandler.playbackState
                            .map((state) => state.playing)
                            .distinct(),
                        builder: (context, snapshot) {
                          final playing = snapshot.data ?? false;
                          if (_lottiePlayPauseController.duration != null) {
                            if (!playing) {
                              _lottiePlayPauseController.forward();
                            } else {
                              _lottiePlayPauseController.animateTo(0.1);
                            }
                          }

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              IntrinsicHeight(
                                child: CircularProgressMini(
                                    max: handler.getTotalDuration),
                              ),
                              ExtendedButton(
                                extendedRadius: 42,
                                child: SizedBox(
                                  height: 18,
                                  child: Lottie.asset(
                                      AppConstants.paths.kLottieAnimationPaths[
                                          animations.playPause]!,
                                      controller: _lottiePlayPauseController,
                                      onLoaded: (controller) {
                                    _lottiePlayPauseController.duration =
                                        Duration(
                                            milliseconds: controller
                                                    .duration.inMilliseconds ~/
                                                2);

                                    _lottiePlayPauseController.animateTo(0.1);
                                  }),
                                ),
                                onTap: () {
                                  playing
                                      ? handler.getAudioHandler.pause()
                                      : handler.getAudioHandler.play();
                                },
                              ),
                            ],
                          );
                        })
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
