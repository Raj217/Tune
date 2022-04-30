import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';

class MainScreen extends StatefulWidget {
  /// This is the main screen of the app. It consists of the curved navigation bar
  /// which is responsible for showing all the primary screens as the user selects
  /// the screen.
  const MainScreen({Key? key}) : super(key: key);
  static String id = 'Bottom Navigator Screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    AppConstants.systemConfigs.lockPortraitMode();
    AppConstants.systemConfigs.setBottomNavBarColor(
        AppConstants.colors.secondaryColors.kBaseCounterColor);
  }

  SvgPicture _icon(icons icon) {
    /// For the screen icons which appear on the bottom navigator
    return SvgPicture.asset(
      AppConstants.paths.kIconPaths[icon]!,
      color: AppConstants.colors.tertiaryColors.kDefaultIconsColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenStateTracker>(builder: (context, tracker, _) {
      return Padding(
        padding: const EdgeInsets.only(top: 1),
        child: SafeArea(
          child: Scaffold(
              backgroundColor:
                  AppConstants.colors.secondaryColors.kBackgroundColor,
              bottomNavigationBar: CurvedNavigationBar(
                index: tracker.getScreenIndex,
                backgroundColor: AppConstants.colors.secondaryColors.kBaseColor,
                height: MediaQuery.of(context).size.height * 0.068,
                animationDuration:
                    AppConstants.durations.kCurvedNavigationBarAnimDuration,
                color: AppConstants.colors.secondaryColors.kBaseCounterColor,
                items: [
                  _icon(icons.home),
                  _icon(icons.downloads),
                  _icon(icons.playlist)
                ],
                onTap: (index) {
                  setState(() {
                    tracker.setScreenIndex = index;
                  });
                },
              ),
              body: tracker.getScreen),
        ),
      );
    });
  }
}
