import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';
import 'dart:math';

import 'package:tune/utils/constant.dart';
import 'package:tune/utils/provider/music/music_handler_admin.dart';
import 'package:tune/widgets/animation/liquid_animation.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/widgets/music/progress/circular_progress_mini.dart';

import '../../screens/audio_player.dart';

class AudioPlayerMini extends StatefulWidget {
  double baseHeight;
  AudioPlayerMini({Key? key, this.baseHeight = kDefaultMiniAudioBaseHeight})
      : super(key: key);

  @override
  State<AudioPlayerMini> createState() => _AudioPlayerMiniState();
}

class _AudioPlayerMiniState extends State<AudioPlayerMini>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;
  bool visible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lottieController = AnimationController(vsync: this);

    try {
      visible = !(Provider.of<MusicHandlerAdmin>(context, listen: false)
              .getTotalDuration ==
          kDurationNotInitialised);
    } catch (e) {
      visible = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LiquidAnimation(),
        Visibility(
          visible: visible,
          child: Consumer<MusicHandlerAdmin>(builder: (context, handler, _) {
            return StreamBuilder<bool>(
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
                    padding: EdgeInsets.only(
                        top: widget.baseHeight, bottom: widget.baseHeight / 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            MusicHandlerAdmin musicHandler =
                                Provider.of<MusicHandlerAdmin>(context,
                                    listen: false);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return AudioPlayer(
                                totalDuration: musicHandler.getTotalDuration,
                                position: musicHandler.getPosition,
                              );
                            })).then((value) =>
                                setBottomNavBarColor(kBaseCounterColor));
                          },
                          child: Stack(alignment: Alignment.center, children: [
                            const Icon(Icons.circle,
                                color: Colors.transparent, size: 40),
                            Transform.rotate(
                              angle: pi,
                              child: SvgPicture.asset(
                                kIconsPath + '/arrow.svg',
                                color: kBackgroundColor,
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          width: 220,
                          child: Center(
                            child: TextScroll(
                                Formatter.scrollText(
                                    width: 220,
                                    style: kAudioTitleTextStyle.copyWith(
                                        color: kBackgroundColor),
                                    text: handler.getTitle),
                                velocity: kTextAutoScrollVelocity,
                                style: kAudioTitleTextStyle.copyWith(
                                    color: kBackgroundColor, fontSize: 13)),
                          ),
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
                            const Icon(
                              Icons.circle,
                              color: Colors.transparent,
                              size: 42,
                            ),
                            CircularProgressMini(max: handler.getTotalDuration),
                            if (playing)
                              GestureDetector(
                                  child: SvgPicture.asset(
                                    '$kIconsPath/pause.svg',
                                    height: 18,
                                    color: kBackgroundColor,
                                  ),
                                  onTap: () {
                                    handler.getAudioHandler.pause();
                                  })
                            else
                              GestureDetector(
                                  child: SvgPicture.asset(
                                    '$kIconsPath/play.svg',
                                    height: 18,
                                    color: kBackgroundColor,
                                  ),
                                  onTap: () {
                                    handler.getAudioHandler.play();
                                  }),
                          ],
                        )
                      ],
                    ),
                  );
                });
          }),
        ),
      ],
    );
  }
}
