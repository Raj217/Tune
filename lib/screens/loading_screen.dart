/// Loading Screen to initialize all the essentials

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tune/widgets/others/tune_logo.dart';
import 'dart:async';

import 'package:tune/utils/music/music_handler_admin.dart';
import 'package:tune/screens/current_music_screen.dart';
import 'package:tune/utils/constant.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  static String id = 'Loading Screen';

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = Timer.periodic(kDurationSplashScreenTime, (timer) {
      Duration totalDuration =
          Provider.of<MusicHandlerAdmin>(context, listen: false)
              .getTotalDuration;
      if (totalDuration != kDurationNotInitialised) {
        // i.e. The audio is ready to play
        timer.cancel();
        Duration position =
            Provider.of<MusicHandlerAdmin>(context, listen: false).getPosition;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CurrentMusicScreen(
                totalDuration: totalDuration,
                position: position,
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TuneLogo(
                logoSize: kSplashScreenLogoSize,
              ),
              GlowText(
                'Tune',
                glowColor: kBaseColor,
                blurRadius: 10,
                style: kBaseTextStyle.copyWith(
                    fontSize: kSplashScreenLogoSize / 4,
                    color: kBaseColor,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
