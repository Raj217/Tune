/// Tune
/// Code By: Rajdristant Ghose
///
/// A music app

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tune/screens/bottom_navigator.dart';
import 'package:tune/screens/main%20screens/home_screen.dart';
import 'package:tune/screens/main%20screens/local_audio_screen.dart';
import 'package:tune/screens/main%20screens/splash_screen.dart';
import 'package:tune/screens/main%20screens/playlist_screen.dart';

import 'screens/audio_related/audio_player_screen.dart';
import 'utils/provider/music/audio_handler_admin.dart';
import 'utils/states/screen_state_tracker.dart';

late AudioHandler _audioHandler;
void main() async {
  _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId:
            'com.ryanheise.myapp.channel.audio_related',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ));
  runApp(const Tune());
}

class Tune extends StatelessWidget {
  const Tune({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) =>
                AudioHandlerAdmin(audioHandler: _audioHandler)),
        ChangeNotifierProvider(
            create: (BuildContext context) => ScreenStateTracker())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tune',
        theme: ThemeData.dark(),
        initialRoute: SplashScreen.id,
        routes: {
          AudioPlayerScreen.id: (BuildContext context) =>
              const AudioPlayerScreen(),
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
