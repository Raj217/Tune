/// Shows the music progress in digital i.e currentPosition : totalDuration format

import 'package:flutter/material.dart';

import 'package:tune/utils/constant.dart';
import 'package:tune/utils/formatter.dart';

class MusicProgressBarDigital extends StatelessWidget {
  MusicProgressBarDigital(
      {Key? key, required this.position, required this.totalDuration})
      : super(key: key);
  Duration position;
  Duration totalDuration;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        Formatter.durationFormatted(position),
        style:
            kBaseTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      Text(
        ' - ${Formatter.durationFormatted(totalDuration)}',
        style: kBaseTextStyle.copyWith(
            color: kGrayLight, fontSize: 13, fontWeight: FontWeight.w500),
      )
    ]);
  }
}
