import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'dart:math';

import 'package:tune/screens/main_screens/primary/home_screen.dart';
import 'package:tune/screens/main_screens/primary/local_audio_screen.dart';
import 'package:tune/screens/main_screens/primary/playlist_screen.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/widgets/music/display/audio_player_mini.dart';
import 'package:tune/widgets/music/display/playlist_viewer_item.dart';

class ScreenStateTracker extends ChangeNotifier {
  /// Index of Screen
  int _screenIndex = 1;

  /// Currently showing avatar (TODO: Make it constant by storing)
  int _avatarIndex = 0;

  ScreenStateTracker() {
    _avatarIndex = Random().nextInt(6);
  }

  /// List of Screens
  final List _screens = const [
    HomeScreen(),
    LocalAudioScreen(),
    PlaylistScreen()
  ];

  /// Initialised once so that it can be used in all the [_screens]
  ///
  /// This value is changed when needed in the different [_screens]
  AudioPlayerMini _audioPlayerMini = AudioPlayerMini();

  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();

  /// Helpful when there is no audio to play, so that the [_audioPlayerMini]
  /// hides instead of throwing error of not getting audio title, etc.
  bool _shouldShowAudioPlayerMini = true;

  /// Toggle between menu screen and main screen
  void toggleMenu() {
    _zoomDrawerController.toggle?.call();
    notifyListeners();
  }

  void changeAvatarIndex(int index) {
    if (index < AppConstants.paths.kAvatarPaths.length) {
      _avatarIndex = index;
    }
  }

  // -------------------------------- Getter methods --------------------------------
  int get getScreenIndex => _screenIndex;

  Widget get getScreen => _screens[_screenIndex];

  bool get getShouldShowAudioPlayerMini => _shouldShowAudioPlayerMini;

  ZoomDrawerController get getZoomDrawController => _zoomDrawerController;

  AudioPlayerMini get getAudioPlayerMini => _audioPlayerMini;

  String get getRandomAvatarPath => AppConstants.paths.kAvatarPaths[
      AppConstants.paths.kAvatarPaths.keys.toList()[_avatarIndex]]!;

  // -------------------------------- Setter methods --------------------------------
  set setScreenIndex(int index) {
    _screenIndex = index;
    notifyListeners();
  }

  set setShouldShowAudioPlayerMini(bool choice) {
    _shouldShowAudioPlayerMini = choice;
    if (choice == true) {
      notifyListeners();
    }
  }

  set setAudioPlayerMini(AudioPlayerMini audioPlayerMini) {
    _audioPlayerMini = audioPlayerMini; //TODO: The player might be disposed
    notifyListeners();
  }
}
