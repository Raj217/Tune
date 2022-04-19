import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/buttons/extended_button.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExtendedButton(
            child: const Icon(
              Icons.close,
              color: kActiveColor,
            ),
            onTap: () {
              Provider.of<ScreenStateTracker>(context, listen: false)
                  .toggleMenu();
            },
          ),
          Center(
            child: ExtendedButton(
              svgHeight: 100,
              svgPath:
                  Provider.of<ScreenStateTracker>(context).getRandomAvatarPath,
              extendedBGColor: kBaseColor,
              extendedRadius: 180,
              onTap: () {
                setState(() {
                  Provider.of<ScreenStateTracker>(context, listen: false)
                      .changeAvatarIndex(Random().nextInt(7));
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
