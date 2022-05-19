import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/widgets/buttons/extended_button.dart';

void createNewPlaylistScreen(
    {required BuildContext context, required String path}) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: AppConstants.decorations.kSongOptionsBGBorderRadius),
      context: context,
      builder: (context) {
        return _CreateNewPlaylistScreen(path: path);
      });
}

class _CreateNewPlaylistScreen extends StatefulWidget {
  final String path;
  const _CreateNewPlaylistScreen({Key? key, required this.path})
      : super(key: key);

  @override
  State<_CreateNewPlaylistScreen> createState() =>
      _CreateNewPlaylistScreenState();
}

class _CreateNewPlaylistScreenState extends State<_CreateNewPlaylistScreen> {
  late TextEditingController _playlistNameController;

  @override
  void initState() {
    _playlistNameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ExtendedButton(
                child: Icon(
                  Icons.clear,
                  size: AppConstants.sizes.kDefaultIconWidth,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ExtendedButton(
                child: Text(
                  'New Playlists',
                  style: AppConstants.textStyles.kSongInfoTitleTextStyle,
                ),
              ),
              ExtendedButton(
                child: Icon(
                  Icons.check,
                  size: AppConstants.sizes.kDefaultIconWidth,
                ),
                onTap: () {
                  Provider.of<AudioHandlerAdmin>(context, listen: false)
                      .addNewPlaylist(
                          playlistName: _playlistNameController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: TextField(
              autofocus: true,
              controller: _playlistNameController,
              style: AppConstants.textStyles.kAudioTitleTextStyle
                  .copyWith(fontSize: 12),
              cursorColor: AppConstants.colors.secondaryColors.kBaseColor,
              decoration: AppConstants.decorations.textFieldDecoration
                  .copyWith(hintText: 'Playlist Name'),
            ),
          )
        ],
      ),
    );
  }
}
