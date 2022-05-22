/// This file contains constant value (setting value) used in various places in
/// Tune
///
/// In future release I might set this for the user customisation that's why
/// not declaring all the classes as constants

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Available animations
enum animations {
  favorite,
  listeningToMusic,
  soundEqualizerBars,
  waveFlow,
  loading,
  playPause
}

/// Available avatars
enum avatars { female1, female2, female3, male1, male2, male3 }

/// Available icons
enum icons {
  appOptions,
  arrow,
  bell,
  changeSong,
  delete,
  downloads,
  fastForward,
  home,
  logo,
  menu,
  pause,
  play,
  playlist,
  repeat,
  repeatThisSong,
  search,
  share,
  shuffle,
  soundWave
}

class AppConstants {
  static final _Angles angles = _Angles();
  static final _Decorations decorations = _Decorations();
  static final _Curves curves = _Curves();
  static final _Colors colors = _Colors();
  static final _SecondaryDurations durations = _SecondaryDurations();
  static final _Names names = _Names();
  static final _Paths paths = _Paths();
  static final _Sizes sizes = _Sizes();
  static final _SystemConfigs systemConfigs = _SystemConfigs();
  static final _SecondaryTextStyles textStyles = _SecondaryTextStyles();
  static final _Velocities velocities = _Velocities();
}

class _Angles {
  final double kZoomDrawerTiltAngle = -12.0;

  final double kCircularProgressMiniStartAngle = -90;
}

class _Curves {
  final Curve kZoomDrawerOpenCurve = Curves.fastOutSlowIn;
  final Curve kZoomDrawerCloseCurve = Curves.easeIn;
}

class _Colors {
  final _SecondaryColors secondaryColors = _SecondaryColors();
  final _TertiaryColors tertiaryColors = _TertiaryColors();
}

class _PrimaryColors {
  /// Not accessible directly by any other file in the app
  /// NOTE: This class should only be accessible by SecondaryColors
  _PrimaryColors();

  static const Color _kBlack = Color(0xFF040303);
  static const Color _kBlackLight = Color(0xFF505050);
  static const Color _kBrown = Color(0xFF7C4223);
  static const Color _kGrayLight = Color(0xFFBABABA);
  static const Color _kWhiteTranslucent = Color(0x99FFFFFF);
  static const Color _kGrayDark = Color(0xFF656565);
  static const Color _kWhite = Color(0xFFFFFFFF);
  static const Color _kYellow = Color(0xFFF7DE8D);
  static const Color _kYellowLight = Color(0xFFEFDCA1);
  static const Color _kYellowDeep = Color(0xFFeffc69);
  static const Color _kGreen = Color(0xFF39e451);
}

class _SecondaryColors {
  /// These are the basic Colors for the app
  _SecondaryColors();
  final Color kBackgroundColor = _PrimaryColors._kBlack;
  final Color kBaseColor = _PrimaryColors._kYellow;

  /// This is for the glow effect
  final Color kBaseLightColor = _PrimaryColors._kYellowLight;
  final Color kBaseCounterColor = _PrimaryColors._kBrown;

  final Color kActiveColor = _PrimaryColors._kWhite;
  final Color kInactiveColor = _PrimaryColors._kGrayLight;
}

class _TertiaryColors {
  /// These colors are customised for that particular widget
  _TertiaryColors();

  /// Track Color of the progress bars
  final Color kCircularProgressBarTrackColor =
      _PrimaryColors._kWhiteTranslucent;

  /// The Default Color of the icons in the app
  final Color kDefaultIconsColor = _SecondaryColors().kActiveColor;

  /// Glow Color of the Poster (shadow as refered in the code)
  final Color kPosterShadowColor = _SecondaryColors().kBaseLightColor;

  /// Background Color of the Options screen which pops up
  final Color kSongOptionsBGColor = _PrimaryColors._kGrayDark;

  /// Color of background of the Toast
  final Color kToastBgColor = _PrimaryColors._kBlackLight;

  /// Color of the Text of Toast
  final Color kToastTextColor = _SecondaryColors().kActiveColor;

  /// Background blur color of logo
  final Color kTuneLogoBackgroundGlowColor = _PrimaryColors._kGreen;

  /// Tune Logo Gradient
  final List<Color> kTuneLogoGradientColor = [
    _PrimaryColors._kGreen,
    _PrimaryColors._kYellowDeep
  ];

  /// Background blur color of logo text
  final Color kTuneTextBackgroundGlowColor = _SecondaryColors().kBaseColor;
}

class _PrimaryDurations {
  static const Duration _quickAnimDuration = Duration(milliseconds: 300);
}

class _SecondaryDurations {
  final Duration kDurationNotInitialised = const Duration(milliseconds: 1);
  final Duration kOneSecond = const Duration(seconds: 1);
  final Duration kQuick = _PrimaryDurations._quickAnimDuration;

  /// For fade out animation of the toast
  final Duration kToastDuration = _PrimaryDurations._quickAnimDuration * 4;

  /// Duration of 1 cycle of flowing liquid lottie animation
  final Duration kDefaultLiquidAnimDuration = const Duration(seconds: 3);

  final Duration kZoomDrawerAnimDuration = _PrimaryDurations._quickAnimDuration;

  final Duration kCurvedNavigationBarAnimDuration =
      _PrimaryDurations._quickAnimDuration;

  final Duration kSplashScreenWaitDuration = const Duration(seconds: 5);

  final Duration soundEqualizerBarsDuration =
      const Duration(milliseconds: 3983);

  final Duration audioProgressDigitalDuration =
      _PrimaryDurations._quickAnimDuration;
}

class _Decorations {
  final double kZoomDrawerBorderRadius = 24.0;
  final BorderRadius kSongOptionsBGBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(40), topRight: Radius.circular(40));
  final BorderRadius kToastBGBorderRadius =
      const BorderRadius.all(Radius.circular(40));

  final textFieldDecoration = InputDecoration(
      isDense: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: AppConstants.colors.secondaryColors.kInactiveColor,
            width: 1.3),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: AppConstants.colors.secondaryColors.kBaseColor, width: 2),
      ));
}

class _Names {
  /// Default values for the various fields like song, artist name, etc.
  /// NOTE: It contains only the string value [_Names], for other default values
  /// like default durations and all, refer to the respective constant classes
  _Names();
  final String kDefaultSongName = 'Untitled Song';
  final String kDefaultArtistName = 'Unknown Artist';
}

class _Paths {
  static const String _kLottieAnimationPath = 'assets/animations';
  static const String _kAvatarPath = 'assets/avatars';
  static const String _kIconPath = 'assets/icons';
  final Map<animations, String> kLottieAnimationPaths = {
    animations.favorite: '$_kLottieAnimationPath/favorite.json',
    animations.listeningToMusic:
        '$_kLottieAnimationPath/listening-to-music.json',
    animations.soundEqualizerBars:
        '$_kLottieAnimationPath/sound-equalizer-bars.json',
    animations.waveFlow: '$_kLottieAnimationPath/wave-flow.json',
    animations.loading: '$_kLottieAnimationPath/loading.json',
    animations.playPause: '$_kLottieAnimationPath/play_pause.json',
  };
  final Map<avatars, String> kAvatarPaths = {
    avatars.female1: '$_kAvatarPath/Female 1.svg',
    avatars.female2: '$_kAvatarPath/Female 2.svg',
    avatars.female3: '$_kAvatarPath/Female 3.svg',
    avatars.male1: '$_kAvatarPath/Male 1.svg',
    avatars.male2: '$_kAvatarPath/Male 2.svg',
    avatars.male3: '$_kAvatarPath/Male 3.svg',
  };

  final Map<icons, String> kIconPaths = {
    icons.appOptions: '$_kIconPath/appOptions.svg',
    icons.arrow: '$_kIconPath/arrow.svg',
    icons.bell: '$_kIconPath/bell.svg',
    icons.changeSong: '$_kIconPath/changeSong.svg',
    icons.delete: '$_kIconPath/delete.svg',
    icons.downloads: '$_kIconPath/downloads.svg',
    icons.fastForward: '$_kIconPath/fastForward.svg',
    icons.home: '$_kIconPath/home.svg',
    icons.menu: '$_kIconPath/menu.svg',
    icons.pause: '$_kIconPath/pause.svg',
    icons.play: '$_kIconPath/play.svg',
    icons.playlist: '$_kIconPath/playlist.svg',
    icons.repeat: '$_kIconPath/repeat.svg',
    icons.repeatThisSong: '$_kIconPath/repeat_this_song.svg',
    icons.search: '$_kIconPath/search.svg',
    icons.share: '$_kIconPath/share.svg',
    icons.shuffle: '$_kIconPath/shuffle.svg',
    icons.soundWave: '$_kIconPath/sound wave.svg',
  };

  final String kDefaultPosterImgPath =
      'assets/essentials/default_poster_img.png';
}

class _Sizes {
  final double kAvatarHeight = 100;

  final double kPosterHeight = 300;
  final double kPosterWidth = 270;

  /// Shadow / Glow
  final double kPosterShadowSpread = 12;

  final double kSplashScreenLogoSize = 150;
  final double kSplashScreenLogoTextGlowSpread = 10;

  final double kDefaultMiniAudioBaseHeight = 120;

  final double kDefaultIconHeight = 15;
  final double kDefaultIconWidth = 18;

  final double kDefaultExtendedButtonRadius = 50;

  final double kCircularProgressMiniSize = 35;
  final double kCircularProgressMiniProgressBarWidth = 2;
  final double kCircularProgressMiniTrackWidth = 1;
}

class _SystemConfigs {
  void lockPortraitMode() => SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  void setBottomNavBarColor(Color color) =>
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(systemNavigationBarColor: color));
}

class _PrimaryTextStyles {
  /// Not accessible directly by any other file in the app
  _PrimaryTextStyles();

  static const TextStyle kBaseFont =
      TextStyle(fontFamily: "Dosis", letterSpacing: 1); // TODO: Change font
}

class _SecondaryTextStyles {
  final TextStyle kAudioTitleTextStyle = _PrimaryTextStyles.kBaseFont.copyWith(
      color: _SecondaryColors().kActiveColor,
      fontSize: 17,
      fontWeight: FontWeight.w700);
  final TextStyle kAudioPlayerMiniTitleTextStyle = _PrimaryTextStyles.kBaseFont
      .copyWith(
          color: _SecondaryColors().kBackgroundColor,
          fontSize: 13,
          fontWeight: FontWeight.w700);
  final TextStyle kAudioArtistTextStyle = _PrimaryTextStyles.kBaseFont.copyWith(
      color: _SecondaryColors().kInactiveColor,
      fontSize: 13,
      fontWeight: FontWeight.w300);

  final TextStyle kSplashScreenTuneTextStyle = _PrimaryTextStyles.kBaseFont
      .copyWith(
          fontSize: _Sizes().kSplashScreenLogoSize / 4,
          color: _SecondaryColors().kBaseLightColor,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w700);

  final TextStyle kSongOptionsTextStyle = _PrimaryTextStyles.kBaseFont.copyWith(
      color: _SecondaryColors().kActiveColor,
      fontWeight: FontWeight.w700,
      fontSize: 20);

  final TextStyle kSongInfoTitleTextStyle = _PrimaryTextStyles.kBaseFont
      .copyWith(
          color: _SecondaryColors().kActiveColor,
          fontWeight: FontWeight.w500,
          fontSize: 17);
  final TextStyle kSongInfoValueTextStyle = _PrimaryTextStyles.kBaseFont
      .copyWith(
          color: _SecondaryColors().kInactiveColor,
          fontWeight: FontWeight.w300,
          fontSize: 15);

  final TextStyle kToastTextStyle = _PrimaryTextStyles.kBaseFont
      .copyWith(color: _TertiaryColors().kToastTextColor, fontSize: 15);
}

class _Velocities {
  final kTextAutoScrollVelocity =
      const Velocity(pixelsPerSecond: Offset(20, 0));
}
