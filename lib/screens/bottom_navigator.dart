/// Bottom curved navigation

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/screens/main%20screens/menu_screen.dart';
import 'package:tune/widgets/music/display/audio_player_mini.dart';

import '../widgets/buttons/icon_button.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);
  static String id = 'Bottom Navigator Screen';

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  @override
  void initState() {
    super.initState();

    lockPortraitMode();
    setBottomNavBarColor(kBaseCounterColor);
  }

  SvgPicture _icon(String iconName) {
    return SvgPicture.asset(
      '$kDefaultIconsPath/$iconName',
      color: kIconsColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<ScreenStateTracker>(builder: (context, tracker, _) {
      return Padding(
        padding: const EdgeInsets.only(top: 1),
        child: SafeArea(
          child: Scaffold(
              backgroundColor: kBackgroundColor,
              bottomNavigationBar: CurvedNavigationBar(
                index: tracker.getIndex,
                backgroundColor: kBaseColor,
                height: screenSize.height * 0.068,
                animationDuration: const Duration(milliseconds: 300),
                color: kBaseCounterColor,
                items: [
                  _icon('home.svg'),
                  _icon('downloads.svg'),
                  _icon('playlist.svg')
                ],
                onTap: (index) {
                  setState(() {
                    tracker.setIndex = index;
                  });
                },
              ),
              body: tracker.getScreen),
        ),
      );
    });
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ScreenStateTracker>(
        builder: (context, tracker, _) {
          return ZoomDrawer(
            borderRadius: 24.0,
            showShadow: true,
            angle: -12.0,
            slideWidth: MediaQuery.of(context).size.width * .65,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.easeIn,
            controller: tracker.getZoomDrawController,
            duration: const Duration(milliseconds: 300),
            mainScreen: const BottomNavigator(),
            menuScreen: const MenuScreen(),
          );
        },
      ),
    );
  }
}
