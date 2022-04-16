/// A mini progress bar to show the progress of the audio

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/provider/music/music_handler_admin.dart';

class CircularProgressMini extends StatefulWidget {
  final Duration _min;
  final Duration _max;

  const CircularProgressMini({
    Key? key,
    required Duration max,
    Duration min = Duration.zero,
  })  : _min = min,
        _max = max,
        super(key: key);

  @override
  State<CircularProgressMini> createState() => _CircularProgressMiniState();
}

class _CircularProgressMiniState extends State<CircularProgressMini> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(kDurationOneSecond, (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: widget._min.inMilliseconds.toDouble(),
      max: widget._max.inMilliseconds.toDouble(),
      initialValue: Provider.of<MusicHandlerAdmin>(context)
          .getPosition
          .inMilliseconds
          .toDouble(),
      appearance: CircularSliderAppearance(
        size: 35,
        startAngle: -90,
        angleRange: 360,
        infoProperties: InfoProperties(
          mainLabelStyle: const TextStyle(color: Colors.transparent),
        ),
        customWidths: CustomSliderWidths(
          progressBarWidth: 2,
          handlerSize: 0,
          trackWidth: 1,
        ),
        customColors: CustomSliderColors(
          progressBarColor: kBaseCounterColor,
          trackColor: kCircularProgressBarTrackColor,
        ),
      ),
    );
  }
}
