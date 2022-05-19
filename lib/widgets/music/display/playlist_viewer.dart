import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class PlaylistViewer extends StatefulWidget {
  List<MediaItem>? audioList;
  PlaylistViewer({Key? key, this.audioList}) : super(key: key);

  @override
  State<PlaylistViewer> createState() => _PlaylistViewerState();
}

class _PlaylistViewerState extends State<PlaylistViewer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
