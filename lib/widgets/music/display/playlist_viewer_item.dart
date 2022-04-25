import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:tune/screens/audio_related/song_options.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'dart:math';

class PlaylistViewerItem extends StatefulWidget {
  final int index;
  final bool currentlyPlaying;
  final void Function() onChangeSongList;
  Color? _color;
  PlaylistViewerItem(
      {Key? key,
      required this.index,
      required this.onChangeSongList,
      this.currentlyPlaying = false,
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
        (widget.currentlyPlaying ? kBaseColor : kInactiveColor);
    MediaItem mediaItem = Provider.of<AudioHandlerAdmin>(context, listen: false)
        .getAudioData[widget.index];
    return InkWell(
      onTap: () async {
        await Provider.of<AudioHandlerAdmin>(context, listen: false)
            .getAudioHandler
            .skipToQueueItem(widget.index);
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatter.stringOverflowHandler(
                      text: mediaItem.title,
                      width: MediaQuery.of(context).size.width / 1.6,
                      style: kAudioTitleTextStyle.copyWith(
                          color: color, fontSize: 13),
                    ),
                    style: kAudioTitleTextStyle.copyWith(
                        color: color, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Text(
                        Formatter.durationFormatted(mediaItem.duration!),
                        style: kAudioArtistTextStyle.copyWith(color: color),
                      ),
                      ExtendedButton(
                        extendedRadius: 25,
                        svgName: 'appOptions',
                        svgHeight: 4,
                        angle: pi / 2,
                        svgColor: color,
                        onTap: () {
                          showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    setBottomNavBarColor(kSongOptionsBGColor);
                                    return SongOptions(
                                      mediaItem: mediaItem,
                                      onChangeSongList: widget.onChangeSongList,
                                    );
                                  })
                              .then((value) =>
                                  setBottomNavBarColor(kBaseCounterColor));
                        },
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: color,
                height: 1,
                width: MediaQuery.of(context).size.width * 0.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
