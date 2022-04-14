import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tune/utils/constant.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/provider/music/music_handler_admin.dart';
import 'package:tune/utils/formatter.dart';

class MusicProgressBar extends StatefulWidget {
  MusicProgressBar({
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
  State<MusicProgressBar> createState() => _MusicProgressBarState();
}

class _MusicProgressBarState extends State<MusicProgressBar>
    with SingleTickerProviderStateMixin {
  late double position;
  bool userChangingBar = false;

  late AnimationController _opacityController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _opacityController = AnimationController(
        vsync: this, duration: kDurationProgressBarOnChangeOpacity)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _opacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicHandlerAdmin>(
      builder: (context, handler, _) {
        Duration pos = handler.getPosition;
        if (!userChangingBar) {
          // Making the movement smooth, so that the bar doesn't keeps jumping
          position = pos.inMilliseconds.toDouble();
        }

        return SleekCircularSlider(
          min: widget._min.inMilliseconds.toDouble(),
          max: widget._max.inMilliseconds.toDouble(),
          initialValue: pos >= widget._max ? 0 : position,
          innerWidget: (val) => Center(
            child: Opacity(
              opacity: _opacityController.value,
              child: Container(
                decoration: const BoxDecoration(
                    color: kGray,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Formatter.durationFormatted(
                        Duration(milliseconds: val.toInt())),
                    style: kBaseTextStyle.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          onChange: (val) {
            position = val;
          },
          onChangeStart: (val) {
            handler.getAudioHandler.pause();
            position = val;
            _opacityController.value =
                1; // Make the changed duration onChange viewer visible as soon as the user starts changing the value
            userChangingBar = true;
          },
          onChangeEnd: (val) async {
            position = val;
            _opacityController.reverse(
                from:
                    1); // Animate the fading effect of duration onChange viewer
            await handler.getAudioHandler
                .seek(Duration(milliseconds: val.toInt()));
            userChangingBar = false;
            handler.getAudioHandler.play();
          },
          appearance: CircularSliderAppearance(
            animationEnabled: false,
            size: kImgWidth * 1.1,
            angleRange: 180,
            startAngle: 180,
            counterClockwise: true,
            infoProperties: InfoProperties(
              mainLabelStyle: const TextStyle(color: Colors.transparent),
            ),
            customColors: CustomSliderColors(
              progressBarColors: [kBaseCounterColor, kBaseColor],
              trackColor: kWhite,
            ),
            customWidths: CustomSliderWidths(
                progressBarWidth: 5, handlerSize: 0, trackWidth: 1),
          ),
        );
      },
    );
  }
}
