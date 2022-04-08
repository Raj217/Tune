/// Poster of the music

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tune/utils/img/poster_shadow.dart';
import 'package:tune/utils/music/music_handler_admin.dart';
import 'package:tune/utils/img/cache_image_provider.dart';
import 'package:tune/utils/constant.dart';
import 'package:tune/utils/img/poster_clipper.dart';
import 'package:provider/provider.dart';

class Poster extends StatefulWidget {
  /// Creates a poster of the image of the song with a special shape using the
  /// ClipPath() and adds 2 shadow background
  ///
  late double _height; // Height of the image
  late double _width; // Width of the image
  late double _spread; // Spread radius of the shadow
  Poster(
      {Key? key,
      double height = kImgHeight,
      double width = kImgWidth,
      double spread = kImgSpread})
      : super(key: key) {
    _height = height;
    _width = width;
    _spread = spread;
  }

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

    return Stack(alignment: Alignment.topCenter, children: [
      Center(
        child: CustomPaint(
          painter: PosterShadow(
            height: widget._height - 4,
            width: widget._width - 4,
            spread: widget._spread + 2,
            color: kBaseColor,
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
            color: kWhiteTranslucent,
            offset: Offset(widget._spread + 2, 0),
          ),
        ),
      ),
      ClipPath(
          clipper:
              PosterClipper(height: widget._height - 3, width: widget._width),
          child: posterImg),
    ]);
  }
}
