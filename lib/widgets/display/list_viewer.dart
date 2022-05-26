import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:tune/screens/main_screens/secondary/change_playlist_screen.dart';
import 'playlist_viewer_item.dart';

import 'package:tune/screens/main_screens/tertiary/audio_options.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/widgets/buttons/extended_button.dart';

enum listStyle { addArtist, noArtist, onlyTitle }

class ListViewer extends StatefulWidget {
  dynamic audios;
  final double? height;
  MediaItem? currentlyPlaying;
  final listStyle styleType;
  ListViewer(
      {Key? key,
      required this.audios,
      this.height,
      this.currentlyPlaying,
      this.styleType = listStyle.noArtist})
      : super(key: key);

  @override
  State<ListViewer> createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> {
  Padding inactiveAudioTile(
      {required MediaItem mediaItem,
      required int index,
      required bool isCurrentlyPlaying}) {
    Color activeColor = isCurrentlyPlaying
        ? AppConstants.colors.secondaryColors.kBaseColor
        : AppConstants.colors.secondaryColors.kActiveColor;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Formatter.stringOverflowHandler(
                  text: mediaItem.title,
                  width: 200,
                  style: AppConstants.textStyles.kAudioTitleTextStyle
                      .copyWith(fontSize: 14, color: activeColor)),
              const SizedBox(height: 5),
              Text(
                mediaItem.artist ?? 'Unknown',
                style: AppConstants.textStyles.kAudioArtistTextStyle
                    .copyWith(fontSize: 10, color: activeColor),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                  Formatter.durationFormatted(mediaItem.duration ??
                      AppConstants.durations.kDurationNotInitialised),
                  style: AppConstants.textStyles.kAudioArtistTextStyle
                      .copyWith(color: activeColor)),
              const SizedBox(width: 10),
              ExtendedButton(
                extendedRadius: 25,
                svgName: icons.appOptions,
                height: 4,
                angle: pi / 2,
                color: activeColor,
                onTap: () {
                  showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            AppConstants.systemConfigs.setBottomNavBarColor(
                                AppConstants
                                    .colors.tertiaryColors.kSongOptionsBGColor);
                            return AudioOptions(
                              index: index,
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
    );
  }

  Widget titleTile(String title, int nSongs) {
    return GestureDetector(
      // TODO: Convert to InkWell
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppConstants.systemConfigs.setBottomNavBarColor(
            AppConstants.colors.secondaryColors.kBackgroundColor);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChangePlaylist(
            playlistName: title,
            audioList: widget.audios[title],
            currentlyPlaying: widget.currentlyPlaying,
          );
        })).then((value) => AppConstants.systemConfigs.setBottomNavBarColor(
            AppConstants.colors.secondaryColors.kBaseCounterColor));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: AppConstants.textStyles.kAudioTitleTextStyle
                    .copyWith(fontSize: 15)),
            Row(
              children: [
                Text(nSongs.toString(),
                    style: AppConstants.textStyles.kAudioArtistTextStyle),
                const SizedBox(width: 10),
                Icon(Icons.chevron_right,
                    size: AppConstants.sizes.kDefaultIconHeight)
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> activeAudioTile(List<MediaItem> audioList) {
    return audioList.asMap().entries.map((entry) {
      int index = entry.key;
      MediaItem mediaItem = entry.value;

      return PlaylistViewerItem(
        index: index,
        isCurrentlyPlaying: mediaItem == widget.currentlyPlaying,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (widget.styleType) {
      case listStyle.addArtist:
        child = ListView.builder(
            shrinkWrap: true,
            itemCount: widget.audios.length,
            itemBuilder: (context, index) {
              return inactiveAudioTile(
                  mediaItem: widget.audios[index],
                  index: index,
                  isCurrentlyPlaying:
                      widget.audios[index] == widget.currentlyPlaying);
            });
        break;
      case listStyle.noArtist:
        child = ListView(children: activeAudioTile(widget.audios));
        break;

      case listStyle.onlyTitle:
        child = ListView.builder(
            shrinkWrap: true,
            itemCount: widget.audios.length,
            itemBuilder: (context, index) {
              String title = widget.audios.keys.toList()[index];
              return titleTile(title, widget.audios[title].length);
            });
        break;
    }
    return SizedBox(height: widget.height, child: child);
  }
}
