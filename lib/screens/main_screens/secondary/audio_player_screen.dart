/// This screen shows the currently playing song and its related functions

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:tune/screens/main_screens/tertiary/audio_options.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/music_progress/audio_progress_bar.dart';
import 'package:tune/widgets/music_progress/audio_progress_digital.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/scroller/scrolling_text.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);
  static String id = 'Audio Player Screen';

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with TickerProviderStateMixin {
  late Size screenSize;

  /// Allowed width for audio title beyond which text will start scrolling
  late double audioTitleWidth;

  /// Allowed width for audio artist beyond which text will start scrolling
  late double audioArtistWidth;

  /// To add this audio in the favorite category
  bool favorite = false;

  /// Control the lottie animation of favoring and unfavored
  late AnimationController _favoriteIconController;

  late AnimationController _lottiePlayPauseController;

  @override
  void initState() {
    super.initState();

    AppConstants.systemConfigs.lockPortraitMode();
    AppConstants.systemConfigs.setBottomNavBarColor(
        AppConstants.colors.secondaryColors.kBackgroundColor);

    _favoriteIconController = AnimationController(vsync: this)
      ..addListener(() {
        if (_favoriteIconController.value >= 0.6) {
          if (favorite == true) {
            _favoriteIconController.animateTo(0.6);
          } else {
            _favoriteIconController
                .animateTo(0)
                .then((value) => _favoriteIconController.reset());
          }
        }
      });

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
  }

  void initSizes() {
    screenSize = MediaQuery.of(context).size;
    audioTitleWidth = screenSize.width * 0.8;
    audioArtistWidth = screenSize.width * 0.8;
  }

  @override
  void dispose() {
    _favoriteIconController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initSizes();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstants.colors.secondaryColors.kBackgroundColor,
        body: Consumer<AudioHandlerAdmin>(
          builder: (context, handler, _) {
            return GestureDetector(
              onVerticalDragEnd: (DragEndDetails details) {
                if (details.velocity.pixelsPerSecond.dy > 0) {
                  Navigator.pop(context);
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenSize.height / 15),
                              child: Provider.of<ScreenStateTracker>(context,
                                      listen: false)
                                  .getPoster,
                            ),
                            const AudioProgressBar(),
                          ],
                        ),
                        ExtendedButton(
                          svgName: icons.appOptions,
                          takeDefaultAsWidth: true,
                          onTap: () {
                            int? index = handler.getPlayer.currentIndex;
                            if (index != null) {
                              showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        AppConstants.systemConfigs
                                            .setBottomNavBarColor(AppConstants
                                                .colors
                                                .tertiaryColors
                                                .kSongOptionsBGColor);
                                        return AudioOptions(
                                          index: index,
                                        );
                                      })
                                  .then((value) => AppConstants.systemConfigs
                                      .setBottomNavBarColor(AppConstants.colors
                                          .secondaryColors.kBackgroundColor));
                            }
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AudioProgressBarDigital(
                        position: handler.getPosition,
                        totalDuration: handler.getTotalDuration),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ScrollingText(
                              text: handler
                                  .getAudioHandler.mediaItem.value?.title,
                              width: audioTitleWidth,
                              style:
                                  AppConstants.textStyles.kAudioTitleTextStyle),
                          ScrollingText(
                              text: handler
                                  .getAudioHandler.mediaItem.value?.artist,
                              width: audioArtistWidth,
                              style: AppConstants
                                  .textStyles.kAudioArtistTextStyle),
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

                          if (_lottiePlayPauseController.duration != null) {
                            if (!playing) {
                              _lottiePlayPauseController.forward();
                            } else {
                              _lottiePlayPauseController.animateTo(0.1);
                            }
                          }

                          favorite = handler.isFavorite(handler.getAudioHandler
                              .mediaItem.value?.extras!['path']);

                          if (_favoriteIconController.duration != null &&
                              favorite) {
                            _favoriteIconController.forward();
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ExtendedButton(
                                  child: Lottie.asset(
                                      AppConstants.paths.kLottieAnimationPaths[
                                          animations.favorite]!,
                                      height: 55,
                                      controller: _favoriteIconController,
                                      onLoaded: (controller) {
                                    _favoriteIconController.duration =
                                        controller.duration;
                                    if (favorite) {
                                      _favoriteIconController.forward();
                                    }
                                  }),
                                  onTap: () async {
                                    setState(() {
                                      favorite = !favorite;
                                      _favoriteIconController.forward().then(
                                          (value) =>
                                              _favoriteIconController.reset());
                                      String path = handler.getAudioHandler
                                          .mediaItem.value?.extras!['path'];
                                      String playlistName = 'favorite';
                                      if (favorite) {
                                        handler.addToPlaylist(
                                            path: path,
                                            playlistName: playlistName);
                                      } else {
                                        handler.removeFromPlaylist(
                                            path: path,
                                            playlistName: playlistName);
                                      }
                                    });
                                  }),
                              ExtendedButton(
                                  extendedRadius: 70,
                                  svgName: icons.changeSong,
                                  height: 25,
                                  color: AppConstants
                                      .colors.secondaryColors.kBaseColor,
                                  onTap: () {
                                    setState(() {
                                      handler.getAudioHandler.skipToPrevious();
                                    });
                                  }),
                              ExtendedButton(
                                extendedRadius: 80,
                                extendedBGColor: AppConstants
                                    .colors.secondaryColors.kBaseColor,
                                child: SizedBox(
                                  height: 40,
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
                              ExtendedButton(
                                  extendedRadius: 70,
                                  angle: pi,
                                  svgName: icons.changeSong,
                                  height: 25,
                                  color: AppConstants
                                      .colors.secondaryColors.kBaseColor,
                                  onTap: () {
                                    setState(() {
                                      handler.getAudioHandler.skipToNext();
                                    });
                                  }),
                              ExtendedButton(
                                  extendedRadius: 55,
                                  svgName: (handler.getPlaylistMode ==
                                          PlayMode.repeatAll
                                      ? icons.repeat
                                      : handler.getPlaylistMode ==
                                              PlayMode.repeatThis
                                          ? icons.repeatThisSong
                                          : icons.shuffle),
                                  height: 16,
                                  onTap: () {
                                    setState(() {
                                      // TODO: Implement it
                                      handler.incrementPlaylistIndex();
                                    });
                                  }),
                            ],
                          );
                        }),
                    SizedBox(height: screenSize.height * 0.1),
                    ExtendedButton(
                        svgName: icons.arrow,
                        color: AppConstants.colors.secondaryColors.kBaseColor,
                        onTap: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
