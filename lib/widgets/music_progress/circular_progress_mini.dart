import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';

class CircularProgressMini extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: StreamBuilder<MediaState>(
        stream: Provider.of<AudioHandlerAdmin>(context).getMediaStateStream,
        builder: (context, snapshot) {
          final mediaState = snapshot.data;
          Provider.of<AudioHandlerAdmin>(context, listen: false).saveUserData();
          return SleekCircularSlider(
            min: _min.inMilliseconds.toDouble(),
            max: _max.inMilliseconds.toDouble(),
            initialValue: mediaState?.position.inMilliseconds.toDouble() ?? 0,
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
                trackColor: AppConstants
                    .colors.tertiaryColors.kCircularProgressBarTrackColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
