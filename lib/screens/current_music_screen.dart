/// This screen shows the currently playing song and its related functions

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:text_scroll/text_scroll.dart';

import 'package:tune/utils/constant.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/utils/music/music_handler_admin.dart';
import 'package:tune/widgets/music/progress/music_progress_bar.dart';
import 'package:tune/widgets/music/progress/music_progress_digital.dart';
import 'package:tune/widgets/img/poster.dart';

class CurrentMusicScreen extends StatefulWidget {
  CurrentMusicScreen(
      {Key? key,
      this.totalDuration = kDurationNotInitialised,
      this.position = Duration.zero})
      : super(key: key);
  static String id = 'Current Music Screen';
  Duration totalDuration;
  Duration position;

  @override
  State<CurrentMusicScreen> createState() => _CurrentMusicScreenState();
}

class _CurrentMusicScreenState extends State<CurrentMusicScreen> {
  /// Total Duration of the audio
  late Duration totalDuration;

  /// Current position of the audio
  late Duration position;

  late Timer timer;

  List<Color> cardButtonColor = [
    kActiveCardButtonColor,
    kInactiveCardButtonColor
  ];
  late Size screenSize;
  late double audioTitleWidth;
  late double audioArtistWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalDuration = widget.totalDuration;
    position = widget.position;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      startTimer();
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<MusicHandlerAdmin>(context, listen: false).dispose();
    timer.cancel();
  }

  void initSizes() {
    screenSize = MediaQuery.of(context).size;
    audioTitleWidth = screenSize.width * 0.8;
    audioArtistWidth = screenSize.width * 0.8;
  }

  @override
  Widget build(BuildContext context) {
    initSizes();
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Consumer<MusicHandlerAdmin>(
          builder: (context, handler, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: screenSize.height / 15),
                        child: Poster(),
                      ),
                      MusicProgressBar(
                        max: totalDuration,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _button(
                          Icon(
                            Icons.circle,
                            color: cardButtonColor[0],
                            size: 10,
                          ),
                          () {}),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: _button(
                            Icon(
                              Icons.circle,
                              color: cardButtonColor[1],
                              size: 10,
                            ),
                            () {}),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MusicProgressBarDigital(
                      position: handler.getPosition,
                      totalDuration: handler.getTotalDuration),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: audioTitleWidth,
                          child: TextScroll(
                              Formatter.scrollText(
                                  width: audioTitleWidth,
                                  style: kAudioTitleTextStyle,
                                  text: handler.getMetaData?.title),
                              velocity: kTextAutoScrollVelocity,
                              style: kAudioTitleTextStyle),
                        ),
                        SizedBox(
                          width: audioArtistWidth,
                          child: Center(
                            child: TextScroll(
                              Formatter.scrollText(
                                  width: audioArtistWidth,
                                  text: handler.getMetaData?.artist,
                                  style: kAudioArtistTextStyle),
                              velocity: kTextAutoScrollVelocity,
                              style: kAudioArtistTextStyle,
                            ),
                          ),
                        )
                      ]),
                  const SizedBox(
                    height: 40,
                  ),
                  StreamBuilder<bool>(
                      stream: handler.getAudioHandler.playbackState
                          .map((state) => state.playing)
                          .distinct(),
                      builder: (context, snapshot) {
                        final playing = snapshot.data ?? false;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _button(
                                SvgPicture.asset(
                                  '$kIconsPath/favorite.svg',
                                  height: 16,
                                  color: kGrayLight,
                                ),
                                () {}),
                            _button(
                                SvgPicture.asset(
                                  '$kIconsPath/changeSong.svg',
                                  height: 25,
                                  color: kBaseColor,
                                ),
                                () {}),
                            if (playing)
                              _button(
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: kBaseColor,
                                        size: 80,
                                      ),
                                      SvgPicture.asset(
                                        '$kIconsPath/pause.svg',
                                        height: 25,
                                        color: kBackgroundColor,
                                      ),
                                    ],
                                  ), () {
                                handler.getAudioHandler.pause();
                              })
                            else
                              _button(
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: kBaseColor,
                                        size: 80,
                                      ),
                                      SvgPicture.asset(
                                        '$kIconsPath/play.svg',
                                        height: 25,
                                        color: kBackgroundColor,
                                      ),
                                    ],
                                  ), () {
                                startTimer();
                                handler.getAudioHandler.play();
                              }),
                            _button(
                                Transform.rotate(
                                  alignment: Alignment.center,
                                  angle: pi,
                                  child: SvgPicture.asset(
                                    '$kIconsPath/changeSong.svg',
                                    height: 25,
                                    color: kBaseColor,
                                  ),
                                ),
                                handler.getAudioHandler.fastForward),
                            _button(
                                SvgPicture.asset(
                                  '$kIconsPath/shuffle.svg',
                                  height: 16,
                                  color: kGrayLight,
                                ),
                                () {}),
                          ],
                        );
                      }),
                  SizedBox(height: screenSize.height * 0.08),
                  _button(
                      SvgPicture.asset(
                        '$kIconsPath/arrow.svg',
                        height: 15,
                        color: kBaseColor,
                      ),
                      () {})
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

GestureDetector _button(Widget widget, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: widget,
  );
}
