import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/screens/main_screens/tertiary/audio_options.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'dart:math';

class PlaylistViewerItem extends StatefulWidget {
  /// Index of the item
  final int index;

  /// Is this item currently playing?
  final bool isCurrentlyPlaying;

  Color? _color;
  PlaylistViewerItem(
      {Key? key,
      required this.index,
      this.isCurrentlyPlaying = false,
      Color? color})
      : _color = color,
        super(key: key);

  set setColor(Color color) => _color = color;
  @override
  State<PlaylistViewerItem> createState() => _PlaylistViewerItemState();
}

class _PlaylistViewerItemState extends State<PlaylistViewerItem> {
  @override
  Widget build(BuildContext context) {
    Color color = widget._color ??
        (widget.isCurrentlyPlaying
            ? AppConstants.colors.secondaryColors.kBaseColor
            : AppConstants.colors.secondaryColors.kInactiveColor);
    MediaItem mediaItem = Provider.of<AudioHandlerAdmin>(context, listen: false)
        .getCurrentPlaylistMediaItems[widget.index];
    return InkWell(
      onTap: () {
        Future.delayed(AppConstants.durations.kQuick);
        Provider.of<AudioHandlerAdmin>(context, listen: false)
            .getAudioHandler
            .skipToQueueItem(widget.index);
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Formatter.stringOverflowHandler(
                text: mediaItem.title,
                width: MediaQuery.of(context).size.width / 1.6,
                style: AppConstants.textStyles.kAudioTitleTextStyle
                    .copyWith(color: color, fontSize: 13),
              ),
              Row(
                children: [
                  Text(
                    Formatter.durationFormatted(mediaItem.duration!),
                    style: AppConstants.textStyles.kAudioArtistTextStyle
                        .copyWith(color: color),
                  ),
                  ExtendedButton(
                    extendedRadius: 25,
                    svgName: icons.appOptions,
                    height: 4,
                    angle: pi / 2,
                    color: color,
                    onTap: () {
                      showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                AppConstants.systemConfigs.setBottomNavBarColor(
                                    AppConstants.colors.tertiaryColors
                                        .kSongOptionsBGColor);
                                return AudioOptions(
                                  index: widget.index,
                                );
                              })
                          .then((value) => AppConstants.systemConfigs
                              .setBottomNavBarColor(AppConstants
                                  .colors.secondaryColors.kBaseCounterColor));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
