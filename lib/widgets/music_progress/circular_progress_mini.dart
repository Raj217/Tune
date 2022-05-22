import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';

class CircularProgressMini extends StatefulWidget {
  final Duration _min;
  final Duration _max;

  /// A mini progress bar to show the progress of the audio_related
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

class _CircularProgressMiniState extends State<CircularProgressMini>
    with TickerProviderStateMixin {
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(AppConstants.durations.kOneSecond, (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: widget._min.inMilliseconds.toDouble(),
      max: widget._max.inMilliseconds.toDouble(),
      initialValue: Provider.of<AudioHandlerAdmin>(context)
          .getPosition
          .inMilliseconds
          .toDouble(),
      appearance: CircularSliderAppearance(
        animationEnabled: false,
        size: AppConstants.sizes.kCircularProgressMiniSize,
        startAngle: AppConstants.angles.kCircularProgressMiniStartAngle,
        angleRange: 360,
        infoProperties: InfoProperties(
          mainLabelStyle: const TextStyle(color: Colors.transparent),
        ),
        customWidths: CustomSliderWidths(
          progressBarWidth:
              AppConstants.sizes.kCircularProgressMiniProgressBarWidth,
          handlerSize: 0,
          trackWidth: AppConstants.sizes.kCircularProgressMiniTrackWidth,
        ),
        customColors: CustomSliderColors(
          progressBarColor:
              AppConstants.colors.secondaryColors.kBaseCounterColor,
          trackColor:
              AppConstants.colors.tertiaryColors.kCircularProgressBarTrackColor,
        ),
      ),
    );
  }
}
