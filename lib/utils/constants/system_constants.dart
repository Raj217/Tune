/// This file contains constant value (setting value) used in various places in
/// Tune
///

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant.dart';

// ---------------------------- Durations ----------------------------
const Duration kDurationSplashScreenTime = Duration(milliseconds: 600);
const Duration kDurationNotInitialised = Duration(milliseconds: 1);
const Duration kDurationOneSecond = Duration(seconds: 1);

/// For fade out animation of the text which appears when the progress bar is
/// changing in audio player screen
const Duration kDurationProgressBarOnChangeOpacity =
    Duration(milliseconds: 800);

/// Duration of 1 cycle of flowing liquid lottie animation
const Duration kDefaultLiquidAnimDuration = Duration(seconds: 3);

// ------------------------------- Color -------------------------------
// ---------------------------- Primary Color ----------------------------
const Color kBackgroundColor = kBlack;
const Color kBaseColor = kYellow;
const Color kBaseLightColor = kYellowLight;
const Color kBaseCounterColor = kBrown;

const Color kActiveColor = kWhite;
const Color kInactiveColor = kGrayLight;

// ---------------------------- Secondary Color ----------------------------
/// To show the active card color on the dots in audio player screen
const Color kActiveCardButtonColor = kWhite;

/// To show the inactive card color on the dots in audio player screen
const Color kInactiveCardButtonColor = kInactiveColor;

/// To show the active card color on the dots in audio player screen
const Color kIconsColor = kActiveColor;

/// Color of background of the Text which appears in audio player while changing the progress bar (music progress digital)
const Color kProgressOnChangeTextBGColor = kGray;

/// Color of the Text which appears in audio player while changing the progress bar (music progress digital)
const Color kProgressOnChangeTextColor = kWhite;

/// Tune Logo Gradient
const List<Color> kTuneLogoGradientColor = [kGreen, kYellowDeep];

/// Background blur color of logo
const Color kTuneLogoBackgroundGlowColor = kGreen;

/// Background blur color of logo text
const Color kTuneTextBackgroundGlowColor = kBaseColor;

/// Color 1 (left) on the poster shadow
const Color kPosterShadowColor1 = kBaseLightColor;

/// Color 2 (right) on the poster shadow
const Color kPosterShadowColor2 = kWhiteTranslucent;

/// Track Color of the progress bars
const Color kCircularProgressBarTrackColor = kWhiteTranslucent;

// ---------------------------- Names ----------------------------
const kDefaultSongName = 'Untitled Song';

// ---------------------------- Paths ----------------------------
const String kDefaultIconsPath = 'assets/icons';
const String kDefaultPosterImgPath = 'assets/essentials/default_poster_img.png';
const String kDefaultLottieAnimationsPath = 'assets/animations';

// ---------------------------- Size ----------------------------
const double kPosterImgHeight = 300;
const double kPosterImgWidth = 270;
const double kPosterImgSpread = 10;

const double kSplashScreenLogoSize = 150;
const double kDefaultLogoSize = 40;

const double kDefaultMiniAudioBaseHeight = 30;

const double kDefaultIconHeight = 15;
const double kDefaultIconWidth = 18;

/// Used in audio player screen
const double kDefaultCardButtonSize = 10;

const double kDefaultExtendedButtonRadius = 50;

// ---------------------------- System Configs ----------------------------
void lockPortraitMode() => SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
void setBottomNavBarColor(Color color) => SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(systemNavigationBarColor: color));

// --------------------------------- Text Style ---------------------------------
final TextStyle kAudioTitleTextStyle =
    kBaseFont.copyWith(fontSize: 17, fontWeight: FontWeight.w800);
final TextStyle kAudioArtistTextStyle = kBaseFont.copyWith(
    color: kGrayLight, fontSize: 13, fontWeight: FontWeight.w300);
final TextStyle kTuneTextSplashScreenTextStyle = kBaseFont.copyWith(
    fontSize: kSplashScreenLogoSize / 4,
    color: kBaseColor,
    fontWeight: FontWeight.w700);

// ---------------------------- Velocity ----------------------------
const kTextAutoScrollVelocity = Velocity(pixelsPerSecond: Offset(20, 0));
