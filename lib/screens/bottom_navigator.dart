/// Bottom curved navigation

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tune/screens/local_audio_screen.dart';
import 'package:tune/screens/playlist_screen.dart';
import 'package:tune/utils/constant.dart';
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
  int _index = 2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: kBaseCounterColor));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 13.0),
          child: CurvedNavigationBar(
            index: _index,
            backgroundColor: Colors.transparent,
            height: screenSize.height * 0.06,
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
                _index = index;
              });
            },
          ),
        ),
        body: screens[_index],
      ),
    );
  }
}
