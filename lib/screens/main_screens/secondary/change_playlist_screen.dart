import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/widgets/buttons/extended_button.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

import '../../../widgets/display/list_viewer.dart';

class ChangePlaylist extends StatelessWidget {
  final String playlistName;
  final List<MediaItem> audioList;
  final MediaItem? currentlyPlaying;
  const ChangePlaylist(
      {Key? key,
      required this.playlistName,
      required this.audioList,
      this.currentlyPlaying})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalScroll(
      screenSize: MediaQuery.of(context).size,
      child: Column(
        children: [
          Row(
            children: [
              ExtendedButton(
                icon: Icons.chevron_left,
                width: 30,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                playlistName,
                style: AppConstants.textStyles.kAudioTitleTextStyle,
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ExtendedButton(
                icon: Icons.play_arrow,
                width: 20,
                color: AppConstants.colors.secondaryColors.kBackgroundColor,
                extendedBGColor: AppConstants.colors.secondaryColors.kBaseColor,
                extendedRadius: 30,
              ),
              const SizedBox(width: 10),
              Text(
                'Play all',
                style: AppConstants.textStyles.kAudioTitleTextStyle,
              ),
              const SizedBox(width: 30),
              Text(
                '${audioList.length.toString()} song${audioList.length > 1 ? 's' : ''}',
                style: AppConstants.textStyles.kAudioArtistTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Divider(
              height: 3,
              color: AppConstants.colors.secondaryColors.kInactiveColor),
          ListViewer(
              audios: audioList,
              styleType: listStyle.addArtist,
              currentlyPlaying: currentlyPlaying),
        ],
      ),
    );
  }
}
