/// Shows the music progress in digital i.e currentPosition : totalDuration format

import 'package:flutter/material.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/formatter.dart';

class MusicProgressBarDigital extends StatelessWidget {
  final Duration position;
  final Duration totalDuration;

  const MusicProgressBarDigital(
      {Key? key, required this.position, required this.totalDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        Formatter.durationFormatted(position),
        style: kAudioArtistTextStyle.copyWith(
            color: kActiveColor, fontWeight: FontWeight.w500),
      ),
      Text(
        ' - ${Formatter.durationFormatted(totalDuration)}',
        style: kAudioArtistTextStyle.copyWith(color: kInactiveColor),
      )
    ]);
  }
}
