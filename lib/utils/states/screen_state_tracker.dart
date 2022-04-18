import 'package:flutter/cupertino.dart';
import 'package:tune/screens/home_screen.dart';
import 'package:tune/screens/local_audio_screen.dart';
import 'package:tune/screens/playlist_screen.dart';

class ScreenStateTracker extends ChangeNotifier {
  /// Index of Screen
  int _index = 1;

  /// List of Screens
  final List screens = const [
    HomeScreen(),
    LocalAudioScreen(),
    PlaylistScreen()
  ];

  // -------------------------------- Getter methods --------------------------------
  int get getIndex {
    return _index;
  }

  Widget get getScreen {
    return screens[_index];
  }

  // -------------------------------- Setter methods --------------------------------
  set setIndex(int index) {
    _index = index;
  }
}
