import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tune/utils/app_constants.dart';

/// Returns a dialog box
/// [activeButtonText] : Color is of the baseColor
/// [ghostButtonText] : Color is of the inactiveColor
Future dialog(
    {required BuildContext context,
    String? message,
    String? title,
    String? activeButtonText,
    void Function()? onPressedActiveButton,
    String? ghostButtonText,
    void Function()? onPressedGhostButton}) async {
  return Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) {
            return _DialogBox(
              activeButtonText: activeButtonText,
              ghostButtonText: ghostButtonText,
              message: message,
              title: title,
              onPressedActiveButton: onPressedActiveButton ?? () {},
              onPressedGhostButton: onPressedGhostButton ?? () {},
            );
          }));
}

class _DialogBox extends StatelessWidget {
  final String? activeButtonText;
  final String? ghostButtonText;
  final String? message;
  final String? title;
  final void Function() onPressedActiveButton;
  final void Function() onPressedGhostButton;
  _DialogBox(
      {Key? key,
      this.activeButtonText,
      this.ghostButtonText,
      this.message,
      this.title,
      required this.onPressedActiveButton,
      required this.onPressedGhostButton})
      : assert(activeButtonText != null || ghostButtonText != null,
            'either of activeButtonText or ghostButtonText must be provided'),
        super(key: key);

  List<Widget> children = [];
  List<Widget> buttons = [];

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      children.add(Text(
        title!,
        style: AppConstants.textStyles.kSongInfoTitleTextStyle,
      ));
    }
    if (message != null) {
      children.add(Text(
        message!,
        style: AppConstants.textStyles.kSongInfoValueTextStyle,
      ));
    }

    if (ghostButtonText != null) {
      buttons.add(GlowButton(
        child: Text(
          ghostButtonText!,
          style: AppConstants.textStyles.kSongInfoTitleTextStyle,
        ),
        onPressed: onPressedGhostButton,
        color: AppConstants.colors.tertiaryColors.kSongOptionsBGColor,
      ));
    }
    if (activeButtonText != null) {
      buttons.add(GlowButton(
        child: Text(
          activeButtonText!,
          style: AppConstants.textStyles.kSongInfoTitleTextStyle.copyWith(
              color: AppConstants.colors.secondaryColors.kBackgroundColor),
        ),
        onPressed: onPressedActiveButton,
        color: AppConstants.colors.secondaryColors.kBaseColor,
      ));
    }
    if (buttons.isNotEmpty) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: buttons,
      ));
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            height: 300,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                color: AppConstants.colors.tertiaryColors.kSongOptionsBGColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
