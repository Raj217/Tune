/// Tune
/// Code By: Rajdristant Ghose
///
/// A music app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune/screens/bottom_navigator.dart';
import 'package:tune/screens/home_screen.dart';
import 'package:tune/screens/local_audio_screen.dart';
import 'package:tune/screens/splash_screen.dart';
import 'package:tune/screens/playlist_screen.dart';

import 'screens/audio_player.dart';
import 'utils/music/music_handler_admin.dart';

void main() {
  runApp(const Tune());
}

class Tune extends StatelessWidget {
  const Tune({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => MusicHandlerAdmin()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tune',
        theme: ThemeData.dark(),
        initialRoute: SplashScreen.id,
        routes: {
          AudioPlayer.id: (BuildContext context) => AudioPlayer(),
          BottomNavigator.id: (BuildContext context) => const BottomNavigator(),
          HomeScreen.id: (BuildContext context) => const HomeScreen(),
          LocalAudioScreen.id: (BuildContext context) =>
              const LocalAudioScreen(),
          PlaylistScreen.id: (BuildContext context) => const PlaylistScreen(),
          SplashScreen.id: (BuildContext context) => const SplashScreen(),
        },
      ),
    );
  }
}
