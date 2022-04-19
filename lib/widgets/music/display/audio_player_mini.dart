import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/animation/liquid_animation.dart';
import 'package:tune/widgets/music/progress/circular_progress_mini.dart';
import '../../../screens/audio_player_screen.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/overflow_handlers/scrolling_text.dart';

class AudioPlayerMini extends StatefulWidget {
  /// Base Height is for the empty space for the audio name and some basic functions and animation
  double baseHeight;

  /// Should the data be shown??
  bool visible;

  /// Name of the song
  String? songName;

  /// Width of the text scroll area
  double? textScrollWidth;

  AudioPlayerMini(
      {Key? key,
      this.baseHeight = kDefaultMiniAudioBaseHeight,
      this.visible = false,
      this.songName = 'Untitled Song',
      this.textScrollWidth})
      : super(key: key);

  set setBaseHeight(double bH) => baseHeight = bH;
  set setVisible(bool v) => visible = v;
  set setSongName(String sN) => songName = sN;
  set setTextScrollWidth(double tSW) => textScrollWidth = tSW;

  @override
  State<AudioPlayerMini> createState() => _AudioPlayerMiniState();
}

class _AudioPlayerMiniState extends State<AudioPlayerMini>
    with TickerProviderStateMixin {
  /// Mini audio visualizer animation controller
  late AnimationController _lottieController;

  /// Width of the text which scrolls automatically
  late double textScrollWidth;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    try {
      if (widget.visible == false) {
        widget.visible =
            !(Provider.of<AudioHandlerAdmin>(context, listen: false)
                    .getTotalDuration ==
                kDurationNotInitialised);
      }
    } catch (e) {
      widget.visible = false;
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textScrollWidth =
        widget.textScrollWidth ?? MediaQuery.of(context).size.width / 1.6;
    return Stack(
      children: [
        const LiquidAnimation(),
        Consumer<AudioHandlerAdmin>(builder: (context, handler, _) {
          return Visibility(
            visible: handler.getNAudioValueNotifier > 0 ? true : false,
            child: StreamBuilder<bool>(
                stream: handler.getAudioHandler.playbackState
                    .map((state) => state.playing)
                    .distinct(),
                builder: (context, snapshot) {
                  final playing = snapshot.data ?? false;
                  if (playing) {
                    _lottieController.repeat();
                  } else {
                    _lottieController.stop();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: kDefaultMiniAudioBaseHeight / 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ExtendedButton(
                          onTap: () {
                            handler.readPlaylist(
                                playlistName: 'all songs.json');
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              Provider.of<ScreenStateTracker>(context,
                                      listen: false)
                                  .setShouldShowAudioPlayerMini = false;
                              return AudioPlayerScreen(
                                totalDuration: handler.getTotalDuration,
                                position: handler.getPosition,
                              );
                            })).then((value) {
                              Provider.of<ScreenStateTracker>(context,
                                      listen: false)
                                  .setShouldShowAudioPlayerMini = true;
                              setBottomNavBarColor(kBaseCounterColor);
                            });
                          },
                          svgName: 'arrow',
                          angle: pi,
                          extendedRadius: 40,
                          svgColor: kBackgroundColor,
                          svgHeight: kDefaultIconHeight / 1.2,
                        ),
                        ScrollingText(
                          text: handler.getTitle == 'Untitled Song'
                              ? widget.songName
                              : handler.getTitle,
                          width: textScrollWidth,
                          style: kAudioTitleTextStyle.copyWith(
                              color: kBackgroundColor, fontSize: 13),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Lottie.asset(
                            kDefaultLottieAnimationsPath +
                                '/sound-equalizer-bars.json',
                            onLoaded: (controller) {
                              _lottieController.duration = controller.duration;
                            },
                            controller: _lottieController,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressMini(max: handler.getTotalDuration),
                            ExtendedButton(
                              extendedRadius: 42,
                              svgName: playing ? 'pause' : 'play',
                              svgHeight: 18,
                              svgColor: kBackgroundColor,
                              onTap: playing
                                  ? () => handler.getAudioHandler.pause()
                                  : () => handler.getAudioHandler.play(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          );
        }),
      ],
    );
  }
}
