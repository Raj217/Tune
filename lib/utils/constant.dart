/// Change of Poster shape can be made in utils/img/poster_clipper.dart

import 'package:flutter/material.dart';

// ---------------------------- Device Values ----------------------------
// ---------------------------- Velocity ----------------------------
const kTextAutoScrollVelocity = Velocity(pixelsPerSecond: Offset(20, 0));

// ---------------------------- Durations ----------------------------
const Duration kDurationSplashScreenTime = Duration(milliseconds: 600);
const Duration kDurationNotInitialised = Duration(milliseconds: 1);
const Duration kDurationProgressBarOnChangeOpacity =
    Duration(milliseconds: 800);
const Duration kDefaultLiquidAnimDuration = Duration(seconds: 3);

// ---------------------------- Default Color ----------------------------
const Color kBackgroundColor = kBlack;
const Color kBaseColor = kYellow;
const Color kBaseCounterColor = kBrown;
const Color kActiveCardButtonColor = kWhite;
const Color kInactiveCardButtonColor = kGrayLight;

// ---------------------------- Size ----------------------------
const double kImgHeight = 300;
const double kImgWidth = 270;
const double kImgSpread = 7;
const double kSplashScreenLogoSize = 150;
const double kDefaultLogoSize = 150;

// ---------------------------- Paths ----------------------------
const String kIconsPath = 'assets/icons';
const String kDefaultPosterImgPath = 'assets/test/default.png';
const String kDefaultLottieAnimationsPath = 'assets/animations';

// ---------------------------- Color ----------------------------
const Color kBlack = Color(0xFF040303);
const kBrown = Color(0xFF7C4223);
const Color kGrayLight = Color(0xFFC4C4C4);
const kPink = Color(0xFFEC4E8B);
const Color kWhiteTranslucent = Color(0x99FFFFFF);
const Color kGray = Color(0xFFADADAD);
const Color kWhite = Color(0xFFFFFFFF);
const Color kYellow = Color(0xFFF7DE8D);
const Color kGreen = Color(0xFF39e451);
const Color kDeepYellow = Color(0xFFeffc69);

// ---------------------------- Text Style ----------------------------
const kBaseTextStyle = TextStyle(fontFamily: 'Mohr Rounded');
final kAudioTitleTextStyle =
    kBaseTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w800);
final kAudioArtistTextStyle = kBaseTextStyle.copyWith(
    color: kGrayLight, fontSize: 13, fontWeight: FontWeight.w300);
