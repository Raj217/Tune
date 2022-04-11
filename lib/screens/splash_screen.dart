/// Loading Screen to initialize all the essentials

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tune/widgets/others/tune_logo.dart';
import 'dart:async';

import 'package:tune/utils/music/music_handler_admin.dart';
import 'package:tune/screens/audio_player.dart';
import 'package:tune/utils/constant.dart';
import 'bottom_navigator.dart';
import '../utils/storage/file_handler.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: kBackgroundColor));
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
    */
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
