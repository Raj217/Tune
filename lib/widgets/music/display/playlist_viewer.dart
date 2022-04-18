import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/provider/music/audio_handler_admin.dart';
import 'playlist_viewer_item.dart';

class PlaylistViewer extends StatefulWidget {
  const PlaylistViewer({Key? key}) : super(key: key);

  @override
  State<PlaylistViewer> createState() => _PlaylistViewerState();
}

class _PlaylistViewerState extends State<PlaylistViewer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioHandlerAdmin>(
      builder: (context, handler, _) {
        List<MediaItem> audioData = handler.getAudioData;
        int? currentlyPlayingIndex = handler.getPlayer.currentIndex;
        return SizedBox(
          height: 250,
          child: ValueListenableBuilder<int>(
              valueListenable: handler.getNAudioValueNotifier,
              child: ValueListenableBuilder<int>(
                valueListenable: handler.getCurrentlyPlayingAudioIndex,
                child: Visibility(
                  visible:
                      handler.getNAudioValueNotifier.value > 0 ? true : false,
                  child: ListView.builder(
                      itemCount: handler.getNAudioValueNotifier.value,
                      itemBuilder: (context, index) {
                        return PlaylistViewerItem(
                          index: index,
                          currentlyPlaying: index == currentlyPlayingIndex,
                        );
                      }),
                ),
                builder: (context, index, child) {
                  if (index >= 0) {
                    handler.updateMediaItem();
                    return child!;
                  } else {
                    return Container();
                  }
                },
              ),
              builder: (context, nSongs, child) {
                handler.updateMediaItem();
                return child!;
              }),
        );
      },
    );
  }
}
