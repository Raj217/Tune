import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:tune/screens/home_screen.dart';
import 'package:tune/screens/local_audio_screen.dart';
import 'package:tune/screens/playlist_screen.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/provider/music/audio_handler_admin.dart';
import 'dart:math';

import '../../widgets/music/display/audio_player_mini.dart';

class ScreenStateTracker extends ChangeNotifier {
  /// Index of Screen
  int _index = 1;

  int _avatarIndex = 0;
  List<String> _avatarPaths = [];

  ScreenStateTracker() {
    _avatarIndex = Random().nextInt(6);
    for (int i = 1; i < 7; i++) {
      if (i < 3) {
        _avatarPaths.add(kDefaultAvatarsPath + 'Female $i.svg');
      } else {
        _avatarPaths.add(kDefaultAvatarsPath + 'Male ${(i % 3) + 1}.svg');
      }
    }
  }

  /// List of Screens
  final List screens = const [
    HomeScreen(),
    LocalAudioScreen(),
    PlaylistScreen()
  ];

  AudioPlayerMini _audioPlayerMini = AudioPlayerMini();

  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();
  bool menuShowing = false;

  bool _shouldShowAudioPlayerMini = true;

  void toggleMenu() {
    _zoomDrawerController.toggle?.call();
    menuShowing = !menuShowing;
    if (menuShowing == true) {
      setBottomNavBarColor(kBackgroundColor);
    } else {
      // Go back to main screen
      setBottomNavBarColor(kBaseCounterColor);
    }
    notifyListeners();
  }

  void changeAvatarIndex(int index) {
    if (index < _avatarPaths.length) {
      _avatarIndex = index;
    }
  }

  // -------------------------------- Getter methods --------------------------------
  int get getIndex => _index;

  Widget get getScreen => screens[_index];

  bool get getShouldShowAudioPlayerMini => _shouldShowAudioPlayerMini;

  ZoomDrawerController get getZoomDrawController => _zoomDrawerController;

  bool get getIsMenuShowing => menuShowing;

  AudioPlayerMini get getAudioPlayerMini => _audioPlayerMini;

  String get getRandomAvatarPath => _avatarPaths[_avatarIndex];
  // -------------------------------- Setter methods --------------------------------
  set setIndex(int index) => _index = index;

  set setShouldShowAudioPlayerMini(bool choice) =>
      _shouldShowAudioPlayerMini = choice;

  set setAudioPlayerMini(AudioPlayerMini audioPlayerMini) {
    _audioPlayerMini = audioPlayerMini;
    notifyListeners();
  }
}
