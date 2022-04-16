/// This file contains constant value (setting value) used in various places in
/// Tune
///
/// TODO: Classify into primary, secondary, tertiary,.. settings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant.dart';

// ---------------------------- Durations ----------------------------
const Duration kDurationSplashScreenTime = Duration(milliseconds: 600);
const Duration kDurationNotInitialised = Duration(milliseconds: 1);
const Duration kDurationProgressBarOnChangeOpacity =
    Duration(milliseconds: 800);
const Duration kDefaultLiquidAnimDuration = Duration(seconds: 3);

// ------------------------------- Default Color -------------------------------
// ---------------------------- Primary Color ----------------------------
const Color kBackgroundColor = kBlack;
const Color kBaseColor = kYellow;
const Color kBaseLightColor = kYellowLight;
const Color kBaseCounterColor = kBrown;
const Color kActiveColor = kWhite;
const Color kInactiveColor = kGrayLight;

// ---------------------------- Secondary Color ----------------------------
const Color kWhiteShadow = kWhiteTranslucent;

const Color kActiveCardButtonColor =
    kWhite; // To show the active card color on the dots in audio player screen
const Color kInactiveCardButtonColor =
    kInactiveColor; // To show the inactive card color on the dots in audio player screen

const Color kIconsColor = kActiveColor;

const Color kProgressOnChangeTextBGColor =
    kGray; // Color of background of the Text which appears in audio player while changing the progress bar (music progress digital)
const Color kProgressOnChangeTextColor =
    kWhite; // Color of the Text which appears in audio player while changing the progress bar (music progress digital)

const List<Color> kTuneLogoGradientColor = [kGreen, kYellowDeep];
const Color kTuneLogoBackgroundGlowColor =
    kGreen; // Background blur color of logo
const Color kTuneTextBackgroundGlowColor =
    kBaseColor; // Background blur color of logo text

const Color kPosterShadowColor1 =
    kBaseLightColor; // Color 1 (left) on the poster shadow
// ---------------------------- Tertiary Color ----------------------------
const Color kPosterShadowColor2 =
    kWhiteTranslucent; // Color 2 (right) on the poster shadow
const Color kCircularProgressBarTrackColor = kWhiteShadow;

// ---------------------------- Paths ----------------------------
const String kIconsPath = 'assets/icons';
const String kDefaultPosterImgPath = 'assets/test/default.png';
const String kDefaultLottieAnimationsPath = 'assets/animations';

// ---------------------------- Size ----------------------------
const double kImgHeight = 300;
const double kImgWidth = 270;
const double kImgSpread = 10;

const double kSplashScreenLogoSize = 150;
const double kDefaultLogoSize = 150;
const double kDefaultMiniAudioBaseHeight = 30;
const double kDefaultIconHeight = 15;
const double kDefaultIconWidth = 18;

// ---------------------------- System Configs ----------------------------
void lockPortraitMode() => SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
void setBottomNavBarColor(Color color) => SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(systemNavigationBarColor: color));

// --------------------------------- Text Style ---------------------------------
final kAudioTitleTextStyle =
    kBaseFont.copyWith(fontSize: 17, fontWeight: FontWeight.w800);
final kAudioArtistTextStyle = kBaseFont.copyWith(
    color: kGrayLight, fontSize: 13, fontWeight: FontWeight.w300);
final TextStyle kTuneTextSplashScreenTextStyle = kBaseFont.copyWith(
    fontSize: kSplashScreenLogoSize / 4,
    color: kBaseColor,
    fontWeight: FontWeight.w700);

// ---------------------------- Velocity ----------------------------
const kTextAutoScrollVelocity = Velocity(pixelsPerSecond: Offset(20, 0));
