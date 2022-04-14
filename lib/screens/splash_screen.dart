/// Loading Screen to initialize all the essentials

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/provider/music/music_handler_admin.dart';
import 'package:tune/utils/storage/file_handler.dart';
import 'package:tune/widgets/others/tune_logo.dart';
import 'dart:async';

import 'package:tune/utils/constant.dart';
import 'bottom_navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String id = 'Loading Screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lockPortraitMode();
    setBottomNavBarColor(kBackgroundColor);

    Future.delayed(kDurationSplashScreenTime).then((_) {
      Navigator.pushNamed(context, BottomNavigator.id);
    });
    /*
    timer = Timer.periodic(kDurationSplashScreenTime, (timer) {
      Duration totalDuration =
          Provider.of<MusicHandlerAdmin>(context, listen: false)
              .getTotalDuration;
      if (totalDuration != kDurationNotInitialised) {
        // i.e. The audio is ready to play
        timer.cancel();
        /*
        Duration position =
            Provider.of<MusicHandlerAdmin>(context, listen: false).getPosition;*/
        Navigator.pushNamed(context, BottomNavigator.id)
            .then((value) => exit(0));
      }
    });*/
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
              GestureDetector(
                onTap: () async {
                  FileHandler.pick().then((filePath) {
                    Provider.of<MusicHandlerAdmin>(context, listen: false)
                        .initAudioHandler(filePath!);
                  });
                },
                child: TuneLogo(
                  logoSize: kSplashScreenLogoSize,
                ),
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
