import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/formatter.dart';

class MusicProgressBarDigital extends StatefulWidget {
  final Duration position;
  final Duration totalDuration;

  /// Shows the audio progress in digital i.e currentPosition : totalDuration format
  const MusicProgressBarDigital(
      {Key? key, required this.position, required this.totalDuration})
      : super(key: key);

  @override
  State<MusicProgressBarDigital> createState() =>
      _MusicProgressBarDigitalState();
}

class _MusicProgressBarDigitalState extends State<MusicProgressBarDigital> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(AppConstants.durations.kOneSecond, (timer) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(
      builder: (context, handler, _) {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            Formatter.durationFormatted(handler.getPosition),
            style: AppConstants.textStyles.kAudioArtistTextStyle.copyWith(
                color: AppConstants.colors.secondaryColors.kActiveColor,
                fontWeight: FontWeight.w400),
          ),
          Text(
            ' - ${Formatter.durationFormatted(handler.getTotalDuration)}',
            style: AppConstants.textStyles.kAudioArtistTextStyle,
          )
        ]);
      },
    );
  }
}
