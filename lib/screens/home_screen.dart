/// Home screen

import 'package:flutter/material.dart';

import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/widgets/others/vertical_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    lockPortraitMode();
    setBottomNavBarColor(kBaseCounterColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: VerticalScroll(
        screenSize: MediaQuery.of(context).size,
        child: Container(),
      ),
    );
  }
}
