import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tune/screens/main_screens/tertiary/edit_audio_info.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/widgets/animation/toast.dart';

class AudioInfo extends StatelessWidget {
  /// Index of the mediaItem to show data about
  final int index;

  /// Shows the common information about the audio file
  AudioInfo({Key? key, required this.index}) : super(key: key) {
    AppConstants.systemConfigs.setBottomNavBarColor(
        AppConstants.colors.secondaryColors.kBackgroundColor);
  }

  Icon _icon(IconData icon) {
    return Icon(
      icon,
      color: AppConstants.colors.tertiaryColors.kDefaultIconsColor,
      size: AppConstants.sizes.kDefaultIconWidth,
    );
  }

  /// Returns a row which contains the title of the data(left) and the value of
  /// the data(right).
  ///
  /// The value when long pressed is copied to the clipboard. The user is notified
  /// of the copy by vibrating and giving a success toast message.
  Padding _infoItem(
      {required String title,
      required String value,
      required BuildContext context}) {
    double maxWidth = MediaQuery.of(context).size.width / 2.5;
    return Padding(
      padding: EdgeInsets.only(
          left: 30 - AppConstants.sizes.kDefaultIconWidth, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppConstants.textStyles.kSongInfoTitleTextStyle),
          GestureDetector(
            onLongPress: () async {
              Clipboard.setData(ClipboardData(text: value));
              HapticFeedback.vibrate();
              toast(context: context, text: 'copied to clipboard');
            },
            child: SizedBox(
              width: Formatter.textSize(value,
                              AppConstants.textStyles.kSongInfoValueTextStyle)
                          .width >
                      maxWidth
                  ? maxWidth
                  : null,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  value,
                  style: AppConstants.textStyles.kSongInfoValueTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaItem mediaItem = Provider.of<AudioHandlerAdmin>(context, listen: false)
        .getCurrentPlaylistMediaItems[index];
    return VerticalScroll(
      screenSize: MediaQuery.of(context).size,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ExtendedButton(
                      extendedRadius: 40,
                      child: _icon(Icons.arrow_back_ios_sharp),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Song Info',
                      style: AppConstants.textStyles.kAudioTitleTextStyle,
                    )
                  ],
                ),
                ExtendedButton(
                  extendedRadius: 30,
                  child: _icon(Icons.edit),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return EditSongInfo(
                        index: index,
                      );
                    }));
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            _infoItem(title: 'Song', value: mediaItem.title, context: context),
            _infoItem(
                title: 'Artist',
                value: mediaItem.artist ?? 'Unknown',
                context: context),
            _infoItem(
                title: 'Playlist',
                value: Provider.of<AudioHandlerAdmin>(context)
                    .getAudioPlaylists(mediaItem.extras!['path'])
                    .join(', '), //TODO: Bug-Handle the list
                context: context),
            _infoItem(
                title: 'Duration',
                value: Formatter.durationFormatted(
                    mediaItem.duration ?? Duration.zero),
                context: context),
            _infoItem(
                title: 'Size',
                value: '${mediaItem.extras?['size'].toStringAsFixed(2) ?? 0}MB',
                context: context),
            _infoItem(
                title: 'Location',
                value: mediaItem.extras?['path'] ?? 'Unknown Path',
                context: context),
          ],
        ),
      ),
    );
  }
}
