import 'package:flutter/material.dart';
import 'package:tune/utils/constants/system_constants.dart';

Future showToast({required BuildContext context, required String text}) {
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
  final Duration duration;
  final String text;
  const _Toast({Key? key, required this.text, this.duration = kToastDuration})
      : super(key: key);

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with TickerProviderStateMixin {
  late AnimationController _opacityController;
  @override
  void initState() {
    _opacityController =
        AnimationController(vsync: this, duration: widget.duration)
          ..addListener(() {
            setState(() {});
          });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      _opacityController.value = 1;
      await Future.delayed(widget.duration);
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
              decoration: const BoxDecoration(
                  color: kToastBgColor,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.text,
                  style: kToastTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
