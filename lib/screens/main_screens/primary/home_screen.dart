import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/app_bar.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return VerticalScroll(
      screenSize: MediaQuery.of(context).size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomAppBar(),
          Provider.of<ScreenStateTracker>(context).getAudioPlayerMini
        ],
      ),
    );
  }
}