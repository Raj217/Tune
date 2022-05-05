import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/widgets/animation/toast.dart';
import 'package:tune/widgets/scroller/value_picker.dart';
import 'audio_info.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/music/display/audio_player_mini.dart';

class AudioOptions extends StatefulWidget {
  /// Index of the mediaItem of the audio to show the options and do changes
  /// to it
  final int index;

  /// Shows and does the various options available for the audio file
  const AudioOptions({Key? key, required this.index}) : super(key: key);

  @override
  State<AudioOptions> createState() => _AudioOptionsState();
}

class _AudioOptionsState extends State<AudioOptions> {
  /// If this is true both speed and pitch of the audio will be changed,
  /// else only the one which is changed by the user will be changed(i.e. the
  /// other one won't change automatically)
  bool changeOther = true;

  /// What are the values you want to pass to [ValuePicke] (i.e. values available
  /// for the user to change speed/pitch)
  List<double> values = [];

  /// Is Speed/Pitch change allowed?
  ///
  /// TODO: Remove this by storing the values
  bool canEditSpeedAndPitch = false;

  /// Either svgName or icon must be provided,
  /// If both are provided icon will be displayed
  GestureDetector _button(
      {IconData? icon,
      icons? svgName,
      required String text,
      required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Row(
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: AppConstants.sizes.kDefaultIconWidth,
                    color:
                        AppConstants.colors.tertiaryColors.kDefaultIconsColor,
                  )
                : SvgPicture.asset(
                    AppConstants.paths.kIconPaths[svgName]!,
                    width: AppConstants.sizes.kDefaultIconWidth,
                    color:
                        AppConstants.colors.tertiaryColors.kDefaultIconsColor,
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: AppConstants.textStyles.kSongOptionsTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(builder: (_, handler, __) {
      for (int i = 0; i <= 20; i++) {
        // 0.0 to 2.0
        values.add(i / 10);
      }
      MediaItem mediaItem = handler.getAudioData[widget.index];
      if (widget.index == handler.getPlayer.currentIndex) {
        canEditSpeedAndPitch = true;
      }
      return Container(
        decoration: BoxDecoration(
            color: AppConstants.colors.tertiaryColors.kSongOptionsBGColor,
            borderRadius: AppConstants.decorations.kSongOptionsBGBorderRadius),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _button(
                    svgName: icons.soundWave,
                    text: 'change pitch',
                    onTap: () {
                      if (canEditSpeedAndPitch) {
                        valuePicker(
                          context: context,
                          values: values,
                          index: (handler.getPlayer.pitch * 10).toInt(),
                          changeOther: changeOther,
                          changeOtherText: 'speed',
                          onChangeOtherBoolFunction: (bool val) {
                            changeOther = val;
                          },
                          onChange: (double val) async {
                            await handler.getPlayer.setPitch(val);
                            if (changeOther == true) {
                              await handler.getPlayer.setSpeed(val);
                            }
                          },
                        );
                      } else {
                        toast(
                            context: context,
                            text:
                                "pitch can be changed of only the currently playing song");
                      }
                    }),
                _button(
                    icon: Icons.speed,
                    text: 'change speed',
                    onTap: () {
                      if (canEditSpeedAndPitch) {
                        valuePicker(
                            context: context,
                            values: values,
                            index: (handler.getPlayer.speed * 10).toInt(),
                            changeOther: changeOther,
                            changeOtherText: 'pitch',
                            onChangeOtherBoolFunction: (bool val) {
                              changeOther = val;
                            },
                            onChange: (double val) async {
                              await handler.getPlayer.setSpeed(val);
                              if (changeOther == true) {
                                await handler.getPlayer.setPitch(val);
                              }
                            });
                      } else {
                        toast(
                            context: context,
                            text:
                                "speed can be changed of only the currently playing song");
                      }
                    }),
                _button(
                    icon: Icons.share_outlined,
                    text: 'share',
                    onTap: () async {
                      await Share.shareFiles([mediaItem.extras!['path']],
                              text: mediaItem.title)
                          .then((value) => Navigator.pop(context));
                    }),
                _button(
                    icon: Icons.info_outline_rounded,
                    text: 'info',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AudioInfo(index: widget.index);
                      })).then((val) => AppConstants.systemConfigs
                          .setBottomNavBarColor(AppConstants
                              .colors.tertiaryColors.kSongOptionsBGColor));
                    }),
                _button(
                    icon: Icons.playlist_remove,
                    text: 'remove from playlist',
                    onTap: () async {
                      await handler.removeAudio(mediaItem: mediaItem);
                      if (handler.getNumberOfAudios == 0) {
                        Provider.of<ScreenStateTracker>(context, listen: false)
                            .setAudioPlayerMini = AudioPlayerMini();
                      }
                      Navigator.pop(context);
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
