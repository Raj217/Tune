import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/app_constants.dart';

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({Key? key}) : super(key: key);

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    _lottieController = AnimationController(
        vsync: this,
        duration: AppConstants.durations.soundEqualizerBarsDuration);
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AudioHandlerAdmin>(context).getIsPlaying) {
      if (_lottieController.duration != null) {
        _lottieController.repeat();
      }
    } else {
      _lottieController.stop();
    }
    return SizedBox(
      height: 40,
      width: 40,
      child: Lottie.asset(
        AppConstants
            .paths.kLottieAnimationPaths[animations.soundEqualizerBars]!,
        controller: _lottieController,
        fit: BoxFit.cover,
      ),
    );
  }
}
