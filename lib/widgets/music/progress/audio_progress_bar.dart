import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/formatter.dart';

class AudioProgressBar extends StatefulWidget {
  const AudioProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar>
    with SingleTickerProviderStateMixin {
  late double position;
  late Timer timer;
  bool userChangingBar = false;

  late AnimationController _opacityController;
  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
        vsync: this, duration: AppConstants.durations.kToastDuration)
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(AppConstants.durations.kOneSecond, (timer) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(
      builder: (context, handler, _) {
        Duration pos = handler.getPosition;
        Duration max = handler.getTotalDuration;
        if (!userChangingBar) {
          // Making the movement smooth, so that the bar doesn't keeps jumping
          position = pos.inMilliseconds.toDouble();
        }
        // TODO: Glitch of onTap
        return SleekCircularSlider(
          min: 0,
          max: max.inMilliseconds.toDouble(),
          initialValue: (pos >= max || pos <= Duration.zero) ? 0 : position,
          innerWidget: (val) => Center(
            child: Opacity(
              opacity: _opacityController.value,
              child: Container(
                decoration: BoxDecoration(
                    color: AppConstants.colors.tertiaryColors.kToastBgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Formatter.durationFormatted(
                        Duration(milliseconds: val.toInt())),
                    style: AppConstants.textStyles.kAudioArtistTextStyle
                        .copyWith(
                            color: AppConstants
                                .colors.tertiaryColors.kToastTextColor),
                  ),
                ),
              ),
            ),
          ),
          onChange: (val) {
            position = val;
          },
          onChangeStart: (val) {
            userChangingBar = true;
            position = val;
            _opacityController.value =
                1; // Make the changed duration onChange viewer visible as soon as the user starts changing the value
          },
          onChangeEnd: (val) async {
            _opacityController.reverse(
                from:
                    1); // Animate the fading effect of duration onChange viewer
            handler.getAudioHandler.seek(Duration(milliseconds: val.toInt()));

            handler.getAudioHandler.play();
            userChangingBar = false;
            position = val;
          },
          appearance: CircularSliderAppearance(
            animationEnabled: false,
            size: AppConstants.sizes.kPosterWidth * 1.1,
            angleRange: 180,
            startAngle: 180,
            counterClockwise: true,
            infoProperties: InfoProperties(
              mainLabelStyle: const TextStyle(color: Colors.transparent),
            ),
            customColors: CustomSliderColors(
              progressBarColors: [
                AppConstants.colors.secondaryColors.kBaseCounterColor,
                AppConstants.colors.secondaryColors.kBaseColor
              ],
              trackColor: AppConstants
                  .colors.tertiaryColors.kCircularProgressBarTrackColor,
            ),
            customWidths: CustomSliderWidths(
                progressBarWidth: 5, handlerSize: 0, trackWidth: 1),
          ),
        );
      },
    );
  }
}
