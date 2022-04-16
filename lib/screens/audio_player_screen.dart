/// This screen shows the currently playing song and its related functions

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/provider/music/music_handler_admin.dart';
import 'package:tune/widgets/music/progress/music_progress_bar.dart';
import 'package:tune/widgets/music/progress/music_progress_digital.dart';
import 'package:tune/widgets/img/poster.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/overflow_handlers/scrolling_text.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer(
      {Key? key,
      this.totalDuration = kDurationNotInitialised,
      this.position = Duration.zero})
      : super(key: key);
  static String id = 'Audio Player Screen';
  final Duration totalDuration;
  final Duration position;

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer>
    with TickerProviderStateMixin {
  /// Total Duration of the audio
  late Duration totalDuration;

  /// Current position of the audio
  late Duration position;

  /// To redraw the screen every second (implemented in initState)
  late Timer timer;

  late Size screenSize;

  /// Allowed width for audio title beyond which text will start scrolling
  late double audioTitleWidth;

  /// Allowed width for audio artist beyond which text will start scrolling
  late double audioArtistWidth;

  /// To add this audio in the favorite category
  bool favorite = false;

  /// Control the lottie animation of favoring and unfavored
  late AnimationController _favoriteIconController;

  /// Card Button Colors
  List<Color> cardButtonColor = [
    kActiveCardButtonColor,
    kInactiveCardButtonColor
  ];

  @override
  void initState() {
    super.initState();

    lockPortraitMode();
    setBottomNavBarColor(kBackgroundColor);

    totalDuration = widget.totalDuration;
    position = widget.position;

    _favoriteIconController = AnimationController(vsync: this)
      ..addListener(() {
        if (favorite == true && _favoriteIconController.value >= 0.6) {
          _favoriteIconController.stop(); // for liking animation
        }
      });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(kDurationOneSecond, (timer) {
        setState(() {}); // Update the screen every second
      });
    });
  }

  void initSizes() {
    screenSize = MediaQuery.of(context).size;
    audioTitleWidth = screenSize.width * 0.8;
    audioArtistWidth = screenSize.width * 0.8;
  }

  Icon _cardButton(int index) {
    return Icon(
      Icons.circle,
      color: cardButtonColor[index],
      size: kDefaultCardButtonSize,
    );
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
                        child: const Poster(),
                      ),
                      MusicProgressBar(
                        max: totalDuration,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(child: _cardButton(0), onTap: () {}),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: GestureDetector(
                            child: _cardButton(1), onTap: () {}),
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
                        ScrollingText(
                            text:
                                handler.getAudioHandler.mediaItem.value?.title,
                            width: audioTitleWidth,
                            style: kAudioTitleTextStyle),
                        ScrollingText(
                            text: handler.getMetaData?.artist,
                            width: audioArtistWidth,
                            style: kAudioArtistTextStyle),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ExtendedButton(
                                child: Lottie.asset(
                                    kDefaultLottieAnimationsPath +
                                        '/favorite.json',
                                    height: 55,
                                    controller: _favoriteIconController,
                                    onLoaded: (controller) {
                                  _favoriteIconController.duration =
                                      controller.duration;
                                }),
                                onTap: () {
                                  setState(() {
                                    favorite = !favorite;
                                    _favoriteIconController.forward().then(
                                        (value) =>
                                            _favoriteIconController.reset());
                                  });
                                }),
                            ExtendedButton(
                                extendedRadius: 70,
                                iconName: 'changeSong',
                                iconHeight: 25,
                                iconColor: kBaseColor,
                                onTap: () {} // TODO: implement
                                ),
                            ExtendedButton(
                                extendedRadius: 80,
                                extendedBGColor: kBaseColor,
                                iconName: (playing ? 'pause' : 'play'),
                                iconHeight: 25,
                                iconColor: kBackgroundColor,
                                onTap: () {
                                  playing
                                      ? handler.getAudioHandler.pause()
                                      : handler.getAudioHandler.play();
                                }),
                            ExtendedButton(
                                extendedRadius: 70,
                                angle: pi,
                                iconName: 'changeSong',
                                iconHeight: 25,
                                iconColor: kBaseColor,
                                onTap: () {
                                  handler.getAudioHandler.skipToNext();
                                } // TODO: Implement
                                ),
                            ExtendedButton(
                                extendedRadius: 55,
                                iconName: (handler.getPlaylistMode ==
                                        PlayMode.repeatAll
                                    ? 'repeat'
                                    : handler.getPlaylistMode ==
                                            PlayMode.repeatThis
                                        ? 'repeat_this_song'
                                        : 'shuffle'),
                                iconHeight: 16,
                                onTap: () {
                                  setState(() {
                                    handler.incrementPlaylistIndex();
                                  });
                                }),
                          ],
                        );
                      }),
                  SizedBox(height: screenSize.height * 0.08),
                  ExtendedButton(
                      iconName: 'arrow',
                      iconColor: kBaseColor,
                      onTap: () {
                        timer.cancel();
                        Navigator.pop(context);
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
