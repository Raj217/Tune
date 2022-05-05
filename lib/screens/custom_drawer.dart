import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:tune/utils/app_constants.dart';

import 'package:tune/utils/states/screen_state_tracker.dart';
import 'main_screens/main_screen.dart';
import 'menu_screens/menu_screen.dart';

class CustomDrawer extends StatelessWidget {
  /// Custom Drawer with the help of Zoom Drawer to show a stylised
  /// menu screen and also add some animations.
  const CustomDrawer({Key? key}) : super(key: key);
  static String id = 'Custom Drawer';

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.5;
    return SafeArea(
      child: Consumer<ScreenStateTracker>(
        builder: (context, tracker, _) {
          return ZoomDrawer(
            borderRadius: AppConstants.decorations.kZoomDrawerBorderRadius,
            showShadow: true,
            angle: AppConstants.angles.kZoomDrawerTiltAngle,
            slideWidth: MediaQuery.of(context).size.width * .65,
            openCurve: AppConstants.curves.kZoomDrawerOpenCurve,
            closeCurve: AppConstants.curves.kZoomDrawerCloseCurve,
            controller: tracker.getZoomDrawController,
            duration: AppConstants.durations.kZoomDrawerAnimDuration,
            mainScreen: const MainScreen(),
            menuScreen: const MenuScreen(),
          );
        },
      ),
    );
  }
}
