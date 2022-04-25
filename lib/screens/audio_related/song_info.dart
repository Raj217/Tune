import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';
import 'package:flutter/services.dart';

import '../../utils/formatter.dart';
import '../../widgets/animation/toast.dart';

class SongInfo extends StatelessWidget {
  final MediaItem mediaItem;
  SongInfo({Key? key, required this.mediaItem}) : super(key: key) {
    setBottomNavBarColor(kBackgroundColor);
  }

  @override
  Widget build(BuildContext context) {
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
                      child: const Icon(
                        Icons.arrow_back_ios_sharp,
                        color: kIconsColor,
                        size: kDefaultIconWidth,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Song Info',
                      style: kAudioTitleTextStyle,
                    )
                  ],
                ),
                ExtendedButton(
                  extendedRadius: 30,
                  child: const Icon(
                    Icons.edit,
                    color: kIconsColor,
                    size: kDefaultIconWidth,
                  ),
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

Padding _infoItem(
    {required String title,
    required String value,
    required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(left: 30 - kDefaultIconWidth, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kSongInfoTitleTextStyle),
        GestureDetector(
          onLongPress: () async {
            Clipboard.setData(ClipboardData(text: value));
            HapticFeedback.vibrate();
            showToast(context: context, text: 'copied to clipboard');
          },
          child: Text(Formatter.stringOverflowHandler(
              text: value, width: 150, style: kSongInfoValueTextStyle)),
        ),
      ],
    ),
  );
}
