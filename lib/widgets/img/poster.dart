/// Poster of the music

import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:tune/utils/img/poster_shadow.dart';
import 'package:tune/utils/provider/music/audio_handler_admin.dart';
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
              height: widget._height,
              width: widget._width + widget._spread * 2,
              spread: widget._spread,
              color: kPosterShadowColor,
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
