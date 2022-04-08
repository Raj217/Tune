/// Tune
/// Code By: Rajdristant Ghose
///
/// A music app

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:tune/screens/loading_screen.dart';

import 'screens/current_music_screen.dart';
import 'utils/music/music_handler_admin.dart';

/// The Audio Handler handles song from all sources(both from screen and from user)
late AudioHandler _audioHandler;

void main() async {
  _audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );

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
                MusicHandlerAdmin(audioHandler: _audioHandler)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tune',
        theme: ThemeData.dark(),
        initialRoute: LoadingScreen.id,
        routes: {
          CurrentMusicScreen.id: (BuildContext context) => CurrentMusicScreen(),
          LoadingScreen.id: (BuildContext context) => const LoadingScreen(),
        },
      ),
    );
  }
}
