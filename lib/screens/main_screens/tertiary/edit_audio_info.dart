import 'package:dialogs/dialogs.dart';
import 'package:dialogs/dialogs/choice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

import '../../../utils/app_constants.dart';
import '../../../widgets/buttons/extended_button.dart';

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
    String? value,
    Widget? child,
    void Function(String text)? onSubmitted,
    TextEditingController? controller,
  }) {
    double maxWidth = MediaQuery.of(context).size.width / 2.5;
    if (value != null && controller != null) {
      controller.value = TextEditingValue(text: value);
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
    // to set the cursor at the end instead of the default beginning
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
            child: child ??
                TextField(
                  controller: controller,
                  style: AppConstants.textStyles.kAudioTitleTextStyle
                      .copyWith(fontSize: 12),
                  cursorColor: AppConstants.colors.secondaryColors.kBaseColor,
                  decoration: AppConstants.decorations.textFieldDecoration,
                  onSubmitted: onSubmitted,
                ),
          ),
        ],
      ),
    );
  }

  late TextEditingController audioTitleController;
  late TextEditingController audioArtistController;
  String? currentPlaylistValue;
  List<String> playlists = [];
  @override
  void initState() {
    audioTitleController = TextEditingController();
    audioArtistController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.systemConfigs.setBottomNavBarColor(
        AppConstants.colors.secondaryColors.kBackgroundColor);
    return Consumer<AudioHandlerAdmin>(
      builder: (context, handler, _) {
        playlists = handler.getAudioPlaylists(
            handler.getCurrentPlaylistMediaItems[widget.index].extras!['path']);
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
                      ChoiceDialog(
                        buttonOkColor: AppConstants.colors.secondaryColors
                            .kBackgroundColor, //TODO: Complete it
                        title: 'Confirm',
                        message: 'Do you want to save the changes?',
                        buttonOkOnPressed: () async {
                          handler
                              .setNewMetaDataForAudio(
                                  index: widget.index,
                                  artist: audioArtistController.value.text,
                                  audioTitle: audioTitleController.value.text)
                              .then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        },
                      ).show(context);
                    },
                  ),
                ],
              ),
              _editItem(
                  title: 'Song',
                  value:
                      handler.getCurrentPlaylistMediaItems[widget.index].title,
                  controller: audioTitleController),
              _editItem(
                  title: 'Artist',
                  value: audioArtistController.value.text != ''
                      ? audioArtistController.value.text
                      : handler.getCurrentPlaylistMediaItems[widget.index]
                              .artist ??
                          'Unknown',
                  controller: audioArtistController,
                  onSubmitted: (text) {
                    setState(() {
                      audioArtistController.value =
                          TextEditingValue(text: text);
                    });
                  }),
              _editItem(
                  title: 'Playlist',
                  child: DropdownButton(
                      // TODO: Make the skeleton work
                      isExpanded: true,
                      value: currentPlaylistValue ?? playlists[0],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      items: playlists.map((String playlist) {
                        return DropdownMenuItem<String>(
                            value: playlist,
                            child: Text(playlist,
                                style: AppConstants
                                    .textStyles.kAudioTitleTextStyle
                                    .copyWith(fontSize: 12)));
                      }).toList(),
                      onChanged: (String? val) {
                        setState(() {
                          currentPlaylistValue = val!;
                        });
                      })), // TODO: Convert it to a value selector and adder
            ],
          ),
        );
      },
    );
  }
}
