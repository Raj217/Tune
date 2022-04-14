import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tune/utils/constant.dart';
import 'dart:math';

import 'package:tune/utils/provider/music/music_handler_admin.dart';

class CircularProgressMini extends StatefulWidget {
  CircularProgressMini({
    Key? key,
    required Duration max,
    Duration min = Duration.zero,
  }) : super(key: key) {
    _min = min;
    _max = max;
  }

  late Duration _min;
  late Duration _max;

  @override
  State<CircularProgressMini> createState() => _CircularProgressMiniState();
}

class _CircularProgressMiniState extends State<CircularProgressMini> {
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          trackColor: kWhiteTranslucent,
        ),
      ),
    );
  }
}
