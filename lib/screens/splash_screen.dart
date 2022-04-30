import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:tune/widgets/others/tune_logo.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';
import '../utils/audio/audio_handler_admin.dart';
import '../utils/states/screen_state_tracker.dart';
import 'custom_drawer.dart';

class SplashScreen extends StatefulWidget {
  /// Initializes the necessary data while showing a simple loading animation
  const SplashScreen({Key? key}) : super(key: key);
  static String id = 'Loading Screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Timer? timer;
  late AnimationController _lottieAnimationController;

  @override
  void initState() {
    super.initState();

    _lottieAnimationController = AnimationController(vsync: this);

    AppConstants.systemConfigs.lockPortraitMode();
    AppConstants.systemConfigs.setBottomNavBarColor(
        AppConstants.colors.secondaryColors.kBackgroundColor);

    Future.delayed(AppConstants.durations.kSplashScreenWaitDuration).then((_) {
      _lottieAnimationController.stop();
      _lottieAnimationController.dispose();
      Navigator.pushNamed(context, CustomDrawer.id).then(

          /// if the user presses back and somehow reaches the splash
          /// (this screen), then close the app instead of being stuck or
          /// again opening the custom drawer(irritating)
          (value) => exit(0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.colors.secondaryColors.kBackgroundColor,
      body: VerticalScroll(
        screenSize: MediaQuery.of(context).size,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'app logo',
                child: TuneLogo(
                  logoSize: AppConstants.sizes.kSplashScreenLogoSize,
                ),
              ),
              Hero(
                tag: 'app name',
                child: GlowText(
                  'Tune',
                  glowColor: AppConstants
                      .colors.tertiaryColors.kTuneTextBackgroundGlowColor,
                  blurRadius:
                      AppConstants.sizes.kSplashScreenLogoTextGlowSpread,
                  style: AppConstants.textStyles.kSplashScreenTuneTextStyle,
                ),
              ),
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  AppConstants.paths
                      .kLottieAnimationPaths[animations.listeningToMusic]!,
                  onLoaded: (controller) {
                    _lottieAnimationController.duration = controller.duration;
                    _lottieAnimationController.repeat();
                  },
                  controller: _lottieAnimationController,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
