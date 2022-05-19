import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

import '../../../utils/app_constants.dart';
import '../../../widgets/buttons/extended_button.dart';
import '../../../widgets/dialog/dialog_box.dart';

class EditSongInfo extends StatefulWidget {
  /// Index of the mediaItem which is to be edited
  final int index;
  const EditSongInfo({Key? key, required this.index}) : super(key: key);

  @override
  State<EditSongInfo> createState() => _EditSongInfoState();
}

class _EditSongInfoState extends State<EditSongInfo> {
  Padding _editItem({
    required String title,
    required String value,
    required TextEditingController controller,
  }) {
    double maxWidth = MediaQuery.of(context).size.width / 2.5;
    controller.value = TextEditingValue(text: value);
    controller.selection = TextSelection.fromPosition(TextPosition(
        offset: controller.text
            .length)); // to set the cursor at the end instead of the default beginning
    return Padding(
      padding: EdgeInsets.only(
          left: 30 - AppConstants.sizes.kDefaultIconWidth, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppConstants.textStyles.kSongInfoTitleTextStyle,
          ),
          SizedBox(
            width: maxWidth,
            child: TextField(
                controller: controller,
                style: AppConstants.textStyles.kAudioTitleTextStyle
                    .copyWith(fontSize: 12),
                cursorColor: AppConstants.colors.secondaryColors.kBaseColor,
                decoration: AppConstants.decorations.textFieldDecoration),
          ),
        ],
      ),
    );
  }

  late TextEditingController audioTitleController;
  late TextEditingController audioArtistController;
  late TextEditingController audioPlaylistController;
  @override
  void initState() {
    audioTitleController = TextEditingController();
    audioArtistController = TextEditingController();
    audioPlaylistController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.systemConfigs.setBottomNavBarColor(
        AppConstants.colors.secondaryColors.kBackgroundColor);
    return Consumer<AudioHandlerAdmin>(
      builder: (context, handler, _) {
        return VerticalScroll(
          screenSize: MediaQuery.of(context).size,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ExtendedButton(
                        extendedRadius: 40,
                        child: Icon(
                          Icons.close,
                          size: AppConstants.sizes.kDefaultIconWidth,
                          color: AppConstants
                              .colors.secondaryColors.kInactiveColor,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Edit Song Info',
                        style: AppConstants.textStyles.kAudioTitleTextStyle,
                      )
                    ],
                  ),
                  ExtendedButton(
                    extendedRadius: 30,
                    child: Icon(Icons.check,
                        size: AppConstants.sizes.kDefaultIconWidth,
                        color: AppConstants.colors.secondaryColors.kBaseColor),
                    onTap: () async {
                      dialog(
                          context: context,
                          title: 'confirm',
                          message: 'Do you want to save it?',
                          ghostButtonText: 'cancel',
                          activeButtonText: 'OK');
                      /*
                      await handler.setNewMetaDataForAudio(
                          index: widget.index,
                          artist: audioArtistController.value.text,
                          audioTitle: audioTitleController.value.text);
                      Future.delayed(AppConstants.durations.kQuick, () {
                        Navigator.pop(context);
                      });
                      */
                    },
                  ),
                ],
              ),
              _editItem(
                  title: 'Song',
                  value:
                      handler.getCurrentPlaylistAudioData[widget.index].title,
                  controller: audioTitleController),
              _editItem(
                  title: 'Artist',
                  value: handler
                          .getCurrentPlaylistAudioData[widget.index].artist ??
                      'Unknown Artist',
                  controller: audioArtistController),
              _editItem(
                  title: 'Playlist',
                  value: handler.getCurrentPlaylistAudioData[widget.index]
                          .extras?['playlist'][0] ??
                      'all',
                  controller:
                      audioPlaylistController), // TODO: Convert it to a value selector and adder
            ],
          ),
        );
      },
    );
  }
}
