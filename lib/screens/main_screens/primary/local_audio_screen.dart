import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:star_menu/star_menu.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/animation/progress.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/display/audio_player_mini.dart';
import 'package:tune/widgets/display/list_viewer.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/utils/storage/file_handler.dart';

import '../tertiary/audio_options.dart';
import '../../../widgets/display/tab_view.dart';

class LocalAudioScreen extends StatefulWidget {
  /// This screen handles the imports from the local storage and also the
  /// displays various playlists
  const LocalAudioScreen({Key? key}) : super(key: key);
  static String id = 'Local Audio Screen';

  @override
  State<LocalAudioScreen> createState() => _LocalAudioScreenState();
}

class _LocalAudioScreenState extends State<LocalAudioScreen>
    with TickerProviderStateMixin {
  late AnimationController _lottieLoadingController;
  ValueNotifier<bool> isLoadingCompleted = ValueNotifier(false);

  @override
  void initState() {
    _lottieLoadingController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _lottieLoadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return VerticalScroll(
      screenSize: screenSize,
      child: Consumer<AudioHandlerAdmin>(builder: (context, handler, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomAppBar(),
                    CustomTabView(
                      tabViewGap: 20,
                      height: MediaQuery.of(context).size.height * (440 / 756),
                      views: [
                        ListViewer(
                          audios: handler.getCurrentPlaylistMediaItems,
                          styleType: listStyle.addArtist,
                          currentlyPlaying:
                              handler.getAudioHandler.mediaItem.value,
                        ),
                        ListViewer(
                          audios: handler.getAudioArtists,
                          styleType: listStyle.onlyTitle,
                        ),
                        ListViewer(
                          audios: handler.getAllPlaylistsWithSize,
                          styleType: listStyle.onlyTitle,
                        ),
                      ],
                      tabs: [
                        CustomTab(text: 'Songs', index: 0),
                        CustomTab(text: 'Artists', index: 1),
                        CustomTab(text: 'Playlists', index: 2)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GlowButton(
                        color: AppConstants.colors.secondaryColors.kBaseColor,
                        child: Text(
                          'DELETE DATA',
                          style: AppConstants.textStyles.kAudioArtistTextStyle
                              .copyWith(
                                  color: AppConstants
                                      .colors.secondaryColors.kBackgroundColor),
                        ),
                        onPressed: () async {
                          FileHandler.delete('cookies.txt');
                        }),
                    StarMenu(
                      params: StarMenuParameters(
                          backgroundParams: BackgroundParams(
                            backgroundColor: Colors.transparent,
                          ),
                          linearShapeParams: LinearShapeParams(
                            space: 10,
                          ),
                          shape: MenuShape.linear,
                          onItemTapped: (index, controller) async {
                            controller.closeMenu();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context, _, __) {
                                    return ValueListenableBuilder(
                                      valueListenable: isLoadingCompleted,
                                      builder: (BuildContext context,
                                          bool isLoadingCompleted,
                                          Widget? child) {
                                        if (isLoadingCompleted == true) {
                                          _lottieLoadingController.stop();
                                          Navigator.pop(context);
                                        }
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 300,
                                            ),
                                            Center(
                                                child: Lottie.asset(
                                                    AppConstants.paths
                                                            .kLottieAnimationPaths[
                                                        animations.loading]!,
                                                    onLoaded: (controller) {
                                              _lottieLoadingController
                                                      .duration =
                                                  controller.duration;
                                              _lottieLoadingController.repeat();
                                            })),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            );
                            FileHandler.pick(file: index == 0 ? true : false)
                                .then((filePaths) async {
                              if (filePaths != null) {
                                isLoadingCompleted.value = false;
                                for (String? path in filePaths) {
                                  if (path != null) {
                                    String? songName =
                                        Formatter.extractSongNameFromPath(path);
                                    await handler
                                        .addAudio(path: path)
                                        .then((value) {
                                      Provider.of<ScreenStateTracker>(context,
                                              listen: false)
                                          .setAudioPlayerMini = AudioPlayerMini(
                                        songName: songName,
                                      );
                                    });
                                  }
                                }
                              }
                              isLoadingCompleted.value = true;
                            });
                          }),
                      lazyItems: () async {
                        return [
                          ExtendedButton(
                            icon: Icons.audio_file,
                            extendedBGColor: AppConstants
                                .colors.secondaryColors.kBaseCounterColor,
                          ),
                          ExtendedButton(
                            icon: Icons.folder,
                            extendedBGColor: AppConstants
                                .colors.secondaryColors.kBaseCounterColor,
                          ),
                        ];
                      },
                      child: ExtendedButton(
                        icon: Icons.add,
                        extendedBGColor:
                            AppConstants.colors.secondaryColors.kBaseColor,
                        color: AppConstants
                            .colors.secondaryColors.kBackgroundColor,
                        takeDefaultAsWidth: true,
                      ),
                    ),
                  ],
                ),
                Provider.of<ScreenStateTracker>(context).getAudioPlayerMini
              ],
            ),
          ],
        );
      }),
    );
  }
}
