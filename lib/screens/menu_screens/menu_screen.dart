import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'package:tune/widgets/buttons/extended_button.dart';

class MenuScreen extends StatefulWidget {
  /// The Menu Screen which will contain data about the user. Currently only a avatar.
  ///
  /// Future plans: Login, settings, profile pic, etc
  const MenuScreen({Key? key}) : super(key: key);
  static String id = 'Menu Screen';

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.colors.secondaryColors.kBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExtendedButton(
            child: Icon(
              Icons.close,
              color: AppConstants.colors.secondaryColors.kActiveColor,
            ),
            onTap: () {
              Provider.of<ScreenStateTracker>(context, listen: false)
                  .toggleMenu();
            },
          ),
          Center(
            child: ExtendedButton(
              height: AppConstants.sizes.kAvatarHeight,
              svgPath: Provider.of<ScreenStateTracker>(context)
                  .getRandomAvatarPath, // TODO: Store this data in local storage and do not change everytime the app launches
              extendedBGColor: AppConstants.colors.secondaryColors.kBaseColor,
              extendedRadius: AppConstants.sizes.kAvatarHeight + 80,
              // TODO: Do something to change the avatar
              /*
              onTap: () {
                setState(() {
                  Provider.of<ScreenStateTracker>(context, listen: false)
                      .changeAvatarIndex(Random().nextInt(7));
                });
              },
              */
            ),
          )
        ],
      ),
    );
  }
}
