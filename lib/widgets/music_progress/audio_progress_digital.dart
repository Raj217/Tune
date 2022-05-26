import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/formatter.dart';

class AudioProgressBarDigital extends StatelessWidget {
  final Duration position;
  final Duration totalDuration;

  /// Shows the audio progress in digital i.e currentPosition : totalDuration format
  const AudioProgressBarDigital(
      {Key? key, required this.position, required this.totalDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaState>(
      stream: Provider.of<AudioHandlerAdmin>(context).getMediaStateStream,
      builder: (context, snapshot) {
        final mediaState = snapshot.data;
        Provider.of<AudioHandlerAdmin>(context, listen: false).saveUserData();
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            Formatter.durationFormatted(mediaState?.position ?? Duration.zero),
            style: AppConstants.textStyles.kAudioArtistTextStyle.copyWith(
                color: AppConstants.colors.secondaryColors.kActiveColor,
                fontWeight: FontWeight.w400),
          ),
          Text(
            ' - ${Formatter.durationFormatted(mediaState?.mediaItem?.duration ?? Duration.zero)}',
            style: AppConstants.textStyles.kAudioArtistTextStyle,
          )
        ]);
      },
    );
  }
}
