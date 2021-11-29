import 'package:bitpack_flutter/src/models.dart';
import 'package:bitpack_flutter/src/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BitpackImage extends StatelessWidget {
  const BitpackImage({
    Key? key,
    required this.path,
    this.options,
    this.width,
    this.height,
  }) : super(key: key);

  final String path;
  final BitpackImageOptions? options;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final _url = buildUrl(
      context,
      path,
      options: options,
    );

    return CachedNetworkImage(
      imageUrl: _url,
      width: width,
      height: height,
      fit: options?.fit ?? BoxFit.contain,
    );
  }
}
