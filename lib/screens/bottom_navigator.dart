/// Bottom curved navigation

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/provider/states/screen_state_tracker.dart';

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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<ScreenStateTracker>(builder: (context, tracker, _) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            bottomNavigationBar: CurvedNavigationBar(
              index: tracker.getIndex,
              backgroundColor: Colors.transparent,
              height: screenSize.height * 0.045,
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
            body: tracker.getScreen,
          ),
        ),
      );
    });
  }
}

SvgPicture _icon(String iconName) {
  return SvgPicture.asset(
    '$kIconsPath/$iconName',
    color: kIconsColor,
  );
}
