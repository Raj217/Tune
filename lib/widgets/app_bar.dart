import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants/system_constants.dart';
import '../utils/states/screen_state_tracker.dart';
import 'buttons/extended_button.dart';

class CustomAppBar extends StatelessWidget {
  late List<int> _showIcons;
  CustomAppBar({Key? key, List<int>? showIcons}) : super(key: key) {
    _showIcons = showIcons ?? [0, 1, 2];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: _showIcons.contains(0) ? true : false,
          child: ExtendedButton(
            svgName: 'menu',
            svgWidth: kDefaultIconWidth,
            onTap: () {
              Provider.of<ScreenStateTracker>(context, listen: false)
                  .toggleMenu();
            },
          ),
        ),
        Row(
          children: [
            Visibility(
                visible: _showIcons.contains(1) ? true : false,
                child: ExtendedButton(svgName: 'search')),
            Visibility(
              visible: _showIcons.contains(2) ? true : false,
              child: ExtendedButton(
                svgName: 'appOptions',
                svgWidth: kDefaultIconWidth,
              ),
            )
          ],
        )
      ],
    );
  }
}
