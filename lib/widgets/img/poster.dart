/// Poster of the music

import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:tune/utils/img/poster_shadow.dart';
import 'package:tune/utils/provider/music/music_handler_admin.dart';
import 'package:tune/utils/img/cache_image_provider.dart';
import 'package:tune/utils/constants/system_constants.dart';
import 'package:tune/utils/img/poster_clipper.dart';
import 'package:provider/provider.dart';

class Poster extends StatefulWidget {
  /// Creates a poster of the image of the song with a special shape using the
  /// ClipPath() and adds 2 shadow background (left and right)

  /// Height of the image
  final double _height;

  /// Width of the image
  final double _width;

  /// Spread radius of the shadow
  final double _spread;

  const Poster(
      {Key? key,
      double height = kPosterImgHeight,
      double width = kPosterImgWidth,
      double spread = kPosterImgSpread})
      : _height = height,
        _width = width,
        _spread = spread,
        super(key: key);

  @override
  State<Poster> createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  @override
  Widget build(BuildContext context) {
    Widget posterImg;
    try {
      posterImg = Image(
        image: CacheImageProvider(
          '',
          Uint8List.fromList(Provider.of<MusicHandlerAdmin>(context)
              .getMetaData!
              .pictures[0]
              .imageData),
        ),
        height: widget._height,
        fit: BoxFit.cover,
      );
    } catch (e) {
      posterImg = Image.asset(
        kDefaultPosterImgPath,
        height: widget._height,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      child: Stack(alignment: Alignment.topCenter, children: [
        Center(
          child: CustomPaint(
            painter: PosterShadow(
              height: widget._height - widget._spread / 2 - 1,
              width: widget._width - widget._spread / 2 - 1,
              spread: widget._spread + 2,
              color: kPosterShadowColor1,
              offset: Offset(-widget._spread - 2, 0),
            ),
          ),
        ),
        Center(
          child: CustomPaint(
            painter: PosterShadow(
              height: widget._height - 4,
              width: widget._width - 4,
              spread: widget._spread + 2,
              color: kPosterShadowColor2,
              offset: Offset(widget._spread + 2, 0),
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
