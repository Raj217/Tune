/// Loading Screen to initialize all the essentials

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'dart:async';

import 'package:tune/widgets/others/tune_logo.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';
import '../bottom_navigator.dart';

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
    super.initState();

    lockPortraitMode();
    setBottomNavBarColor(kBackgroundColor);

    Future.delayed(kDurationSplashScreenTime).then((_) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CustomDrawer();
      })).then((value) => exit(0));
    }); // Delay to show the splash screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: VerticalScroll(
        screenSize: MediaQuery.of(context).size,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TuneLogo(
                logoSize: kSplashScreenLogoSize,
              ),
              GlowText(
                'Tune',
                glowColor: kTuneTextBackgroundGlowColor,
                blurRadius: 10,
                style: kTuneTextSplashScreenTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
