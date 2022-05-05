import 'package:flutter/material.dart';
import 'package:tune/utils/app_constants.dart';

/// Displays a toast for [AppConstants.durations.kToastDuration] duration
/// and fades away with animation
Future toast({required BuildContext context, required String text}) {
  return Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) {
            return _Toast(
              text: text,
            );
          }));
}

class _Toast extends StatefulWidget {
  final Duration _duration;
  final String text;
  // TODO: Implement curves
  _Toast({Key? key, required this.text, Duration? duration})
      : _duration = duration ?? AppConstants.durations.kToastDuration,
        super(key: key);

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with TickerProviderStateMixin {
  late AnimationController _opacityController;
  @override
  void initState() {
    _opacityController =
        AnimationController(vsync: this, duration: widget._duration)
          ..addListener(() {
            setState(() {});
          });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      _opacityController.value = 1;
      await Future.delayed(widget._duration);
      await _opacityController.reverse(from: 1);
      Navigator.pop(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Opacity(
            opacity: _opacityController.value,
            child: Container(
              decoration: BoxDecoration(
                  color: AppConstants.colors.tertiaryColors.kToastBgColor,
                  borderRadius: AppConstants.decorations.kToastBGBorderRadius),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.text,
                  style: AppConstants.textStyles.kToastTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
