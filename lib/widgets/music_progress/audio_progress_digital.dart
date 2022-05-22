import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/formatter.dart';

class AudioProgressBarDigital extends StatefulWidget {
  final Duration position;
  final Duration totalDuration;

  /// Shows the audio progress in digital i.e currentPosition : totalDuration format
  const AudioProgressBarDigital(
      {Key? key, required this.position, required this.totalDuration})
      : super(key: key);

  @override
  State<AudioProgressBarDigital> createState() =>
      _AudioProgressBarDigitalState();
}

class _AudioProgressBarDigitalState extends State<AudioProgressBarDigital> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(
          AppConstants.durations.audioProgressDigitalDuration, (timer) {
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
