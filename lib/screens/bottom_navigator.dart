/// Bottom curved navigation

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tune/screens/local_audio_screen.dart';
import 'package:tune/screens/playlist_screen.dart';
import 'package:tune/utils/constant.dart';
import 'package:tune/utils/provider/states/screen_state_tracker.dart';
import 'home_screen.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);
  static String id = 'Bottom Navigator Screen';

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final List screens = const [
    HomeScreen(),
    LocalAudioScreen(),
    PlaylistScreen()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lockPortraitMode();
    setBottomNavBarColor(kBaseCounterColor);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer<ScreenStateTracker>(builder: (context, tracker, _) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 13.0),
            child: CurvedNavigationBar(
              index: tracker.getIndex,
              backgroundColor: kBaseColor,
              height: screenSize.height * 0.045,
              animationDuration: const Duration(milliseconds: 300),
              color: kBaseCounterColor,
              items: [
                SvgPicture.asset(
                  '$kIconsPath/home.svg',
                  color: kWhite,
                ),
                SvgPicture.asset(
                  '$kIconsPath/downloads.svg',
                  color: kWhite,
                ),
                SvgPicture.asset(
                  '$kIconsPath/playlist.svg',
                  color: kWhite,
                ),
              ],
              onTap: (index) {
                setState(() {
                  tracker.setIndex = index;
                });
              },
            ),
          ),
          body: tracker.getScreen,
        ),
      );
    });
  }
}
