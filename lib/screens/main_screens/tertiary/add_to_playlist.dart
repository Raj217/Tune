import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';

Future<void> addToPlaylist(
    {required BuildContext context, required currentAudioPath}) async {
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return _AddToPlaylist(
          currentAudioPath: currentAudioPath,
        );
      });
  return;
}

class _AddToPlaylist extends StatefulWidget {
  final String currentAudioPath;
  const _AddToPlaylist({Key? key, required this.currentAudioPath})
      : super(key: key);

  @override
  State<_AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<_AddToPlaylist> {
  final Color bgColor = const Color(0xFF505050);
  @override
  void initState() {
    AppConstants.systemConfigs.setBottomNavBarColor(bgColor);
    super.initState();
  }

  bool testBool = false;

  /// Either a icon will be displayed or a checkbox
  ///
  /// For onTap of checkBox newValue is passed so that the playlist in
  /// AudioHandlerAdmin can be updated
  Padding _button(
      {required String text,
      required void Function(bool newValue) onTap,
      IconData? icon,
      bool? checkBoxValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          onTap(checkBoxValue ?? false);
        },
        child: Row(
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: AppConstants.sizes.kDefaultIconWidth + 5,
                    color: AppConstants.colors.secondaryColors.kBaseColor,
                  )
                : GlowCheckbox(
                    color: AppConstants.textStyles.kSongOptionsTextStyle.color,
                    enable: true,
                    value: checkBoxValue!,
                    checkColor:
                        AppConstants.colors.secondaryColors.kBackgroundColor,
                    onChange: onTap),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: icon != null
                  ? AppConstants.textStyles.kSongOptionsTextStyle.copyWith(
                      color: AppConstants.colors.secondaryColors.kBaseColor)
                  : AppConstants.textStyles.kSongOptionsTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(
      builder: (context, handler, _) {
        List<Padding> children = [];
        children
            .add(_button(icon: Icons.add, text: 'New Playlist', onTap: (_) {}));
        for (String playlistName in handler.getAllPlaylists.keys) {
          children.add(
            _button(
                checkBoxValue: handler.getAllPlaylists[playlistName]
                    ?.contains(widget.currentAudioPath),
                text: playlistName,
                onTap: (newVal) {
                  setState(() {
                    if (handler.getAllPlaylists[playlistName]
                            ?.contains(widget.currentAudioPath) ??
                        false) {
                      handler.removeFromPlaylist(
                          path: widget.currentAudioPath,
                          playlistName: playlistName); //TODO: Clean
                    } else {
                      handler.addToPlaylist(
                          path: widget.currentAudioPath,
                          playlistName: playlistName);
                    }
                  });
                }),
          );
        }
        return Container(
          height: 300,
          padding: const EdgeInsets.only(left: 20, top: 50),
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius:
                  AppConstants.decorations.kSongOptionsBGBorderRadius),
          child: SingleChildScrollView(
            child: Column(children: children),
          ),
        );
      },
    );
  }
}
