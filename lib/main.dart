/// Tune
/// Code By: Rajdristant Ghose
///
/// A audio app
/// Currently only supports for songs but in future versions it will customised
/// for podcasts and other audio files

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/states/screen_state_tracker.dart';
import 'screens/custom_drawer.dart';
import 'screens/menu_screens/menu_screen.dart';
import 'screens/splash_screen.dart';

late AudioHandler _audioHandler;

Future<void> main() async {
  _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.raj.tune.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ));
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const Tune());
}

class Tune extends StatelessWidget {
  const Tune({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AudioHandlerAdmin>(
            create: (BuildContext context) =>
                AudioHandlerAdmin(audioHandler: _audioHandler)),
        ChangeNotifierProvider<ScreenStateTracker>(
            create: (BuildContext context) => ScreenStateTracker()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tune',
        theme: ThemeData.dark().copyWith(
            // Overscroll Glow color for ListView
            colorScheme: ColorScheme.fromSwatch(
                accentColor:
                    AppConstants.colors.secondaryColors.kInactiveColor),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppConstants.colors.secondaryColors.kBaseColor,
              selectionHandleColor:
                  AppConstants.colors.secondaryColors.kBaseColor,
            )),
        initialRoute: SplashScreen.id,
        routes: {
          /// I have mentioned only the following routes since the other need
          /// some initialisation value which is calculated while the app is
          /// running
          ///
          /// while some like the home, local_audio,etc don't need routes as
          /// bottom navigator (main screen) will handle that
          CustomDrawer.id: (BuildContext context) => const CustomDrawer(),
          MenuScreen.id: (BuildContext context) => const MenuScreen(),
          MenuScreen.id: (BuildContext context) => const MenuScreen(),
          SplashScreen.id: (BuildContext context) => const SplashScreen(),
        },
      ),
    );
  }
}
