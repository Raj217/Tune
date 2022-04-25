import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tune/screens/audio_related/song_info.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/widgets/animation/toast.dart';
import 'package:tune/widgets/scroller/value_picker.dart';

import '../../utils/states/screen_state_tracker.dart';
import '../../widgets/music/display/audio_player_mini.dart';

class SongOptions extends StatefulWidget {
  final MediaItem? mediaItem;
  final void Function()? onChangeSongList;
  const SongOptions({Key? key, this.mediaItem, this.onChangeSongList})
      : super(key: key);

  @override
  State<SongOptions> createState() => _SongOptionsState();
}

class _SongOptionsState extends State<SongOptions> {
  bool changeOther = true;
  List<double> values = [];
  bool canEditSpeedAndPitch = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(builder: (_, handler, __) {
      for (int i = 0; i <= 30; i++) {
        values.add(i / 10);
      }
      if (widget.mediaItem != null &&
          widget.mediaItem == handler.getAudioHandler.mediaItem.value) {
        canEditSpeedAndPitch = true;
      }
      return Container(
        decoration: const BoxDecoration(
          color: kSongOptionsBGColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _button(
                    svgName: 'sound wave',
                    text: 'change pitch',
                    onTap: () {
                      if (canEditSpeedAndPitch) {
                        showValueScroller(
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
                        showToast(
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
                        showValueScroller(
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
                        showToast(
                            context: context,
                            text:
                                "speed can be changed of only the currently playing song");
                      }
                    }),
                _button(
                    icon: Icons.share_outlined,
                    text: 'share',
                    onTap: () async {
                      await Share.shareFiles(
                              [widget.mediaItem?.extras!['path']],
                              text: widget.mediaItem?.title)
                          .then((value) => Navigator.pop(context));
                    }),
                _button(
                    icon: Icons.info_outline_rounded,
                    text: 'info',
                    onTap: () {
                      if (widget.mediaItem != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SongInfo(mediaItem: widget.mediaItem!);
                        })).then(
                            (val) => setBottomNavBarColor(kSongOptionsBGColor));
                      }
                    }),
                _button(
                    icon: Icons.playlist_remove,
                    text: 'remove from playlist',
                    onTap: () async {
                      await handler.removeAudio(mediaItem: widget.mediaItem);
                      if (widget.onChangeSongList != null) {
                        widget.onChangeSongList!();
                      }
                      if (handler.getNAudioValueNotifier == 0) {
                        Provider.of<ScreenStateTracker>(context, listen: false)
                            .setAudioPlayerMini = AudioPlayerMini(
                          visible: false,
                        );
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

Future<void> showValueScroller(
    {required BuildContext context,
    required List<double> values,
    required bool changeOther,
    required String changeOtherText,
    required void Function(double value) onChange,
    required void Function(bool value) onChangeOtherBoolFunction,
    int index = 10}) async {
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ValuePicker(
            values: values,
            onValueChange: onChange,
            index: index,
            changeOther: changeOther,
            changeOtherText: changeOtherText,
            onChangeOtherBoolFunction: onChangeOtherBoolFunction);
      });
}

GestureDetector _button(
    {IconData? icon,
    String? svgName,
    required String text,
    required void Function() onTap}) {
  /// Either svgName or icon must be provided,
  /// If both are provided icon will be displayed
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(top: 18, left: 18),
      child: Row(
        children: [
          icon != null
              ? Icon(
                  icon,
                  size: kDefaultIconWidth,
                  color: kIconsColor,
                )
              : SvgPicture.asset(
                  kDefaultIconsPath + '/$svgName.svg',
                  width: kDefaultIconWidth,
                  color: kIconsColor,
                ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: kSongOptionsTextStyle,
          ),
        ],
      ),
    ),
  );
}
