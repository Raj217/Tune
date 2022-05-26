import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:provider/provider.dart';
import 'package:tune/widgets/others/tune_logo.dart';

import '../utils/app_constants.dart';
import '../utils/states/screen_state_tracker.dart';
import 'buttons/extended_button.dart';

class CustomAppBar extends StatelessWidget {
  late List<int> _showIcons;
  CustomAppBar({Key? key, List<int>? showIcons}) : super(key: key) {
    _showIcons = showIcons ?? [0, 1, 3];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: _showIcons.contains(0),
              child: ExtendedButton(
                svgName: icons.menu,
                takeDefaultAsWidth: true,
                onTap: () {
                  Provider.of<ScreenStateTracker>(context, listen: false)
                      .toggleMenu();
                },
              ),
            ),
            Row(
              children: [
                Visibility(
                    visible: _showIcons.contains(2),
                    child: ExtendedButton(svgName: icons.search)),
                Visibility(
                  visible: _showIcons.contains(3),
                  child: ExtendedButton(
                    svgName: icons.appOptions,
                    takeDefaultAsWidth: true,
                  ),
                )
              ],
            )
          ],
        ),
        Visibility(
          visible: _showIcons.contains(1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'app logo',
                child: TuneLogo(
                  logoSize: 30,
                ),
              ),
              Hero(
                tag: 'app name',
                child: GlowText(
                  'Tune',
                  style: AppConstants.textStyles.kSplashScreenTuneTextStyle
                      .copyWith(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
