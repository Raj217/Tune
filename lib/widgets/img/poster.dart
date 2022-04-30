/// Poster of the audio

import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:tune/utils/img/poster_shadow.dart';
import 'package:tune/utils/audio/audio_handler_admin.dart';
import 'package:tune/utils/img/cache_image_provider.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/img/poster_clipper.dart';
import 'package:provider/provider.dart';

class Poster extends StatefulWidget {
  /// Creates a poster of the image of the song with a special shape using the
  /// ClipPath() and adds a shadow background spread (glow effect)
  ///
  /// Initially the glow was of 2 color but was not very prominent, moreover it
  /// was not looking good due to the offset (delay in displaying the poster),
  /// TODO: Add gradient glow effect
  /// TODO: Custom crop the poster
  /// TODO: Add AI to remove the unnecessary extra bg (black color strips)

  /// Height of the image
  final double _height;

  /// Width of the image
  final double _width;

  /// Spread radius of the shadow
  final double _spread;

  Poster({Key? key, double? height, double? width, double? spread})
      : _height = height ?? AppConstants.sizes.kPosterHeight,
        _width = width ?? AppConstants.sizes.kPosterWidth,
        _spread = spread ?? AppConstants.sizes.kPosterShadowSpread,
        super(key: key);

  @override
  State<Poster> createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  @override
  Widget build(BuildContext context) {
    Image posterImg;
    List<int> imgData = Provider.of<AudioHandlerAdmin>(context).getThumbnail;
    if (imgData.isNotEmpty) {
      posterImg = Image(
        image: CacheImageProvider(
          imgData.toString(),
          Uint8List.fromList(imgData),
        ),
        height: widget._height,
        fit: BoxFit.cover,
      );
    } else {
      posterImg = Image.asset(
        AppConstants.paths.kDefaultPosterImgPath,
        height: widget._height,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      child: Stack(alignment: Alignment.topCenter, children: [
        Center(
          child: CustomPaint(
            painter: PosterShadow(
              height: widget._height,
              width: widget._width + widget._spread * 2,
              spread: widget._spread,
              color: AppConstants.colors.tertiaryColors.kPosterShadowColor,
            ),
          ),
        ),
        ClipPath(
            clipper:
                PosterClipper(height: widget._height - 3, width: widget._width),
            child: posterImg),
      ]),
    );
  }
}
