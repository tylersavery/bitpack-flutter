import 'package:bitpack_flutter/bitpack_flutter.dart';
import 'package:bitpack_flutter/src/models.dart';
import 'package:flutter/material.dart';

String queryStringUrl(
  BuildContext context,
  path, [
  Map<String, dynamic> params = const {},
]) {
  String queryString = "";
  if (params.isNotEmpty) {
    queryString = "?";
    params.forEach((k, v) {
      queryString += "$k=${v.toString()}&";
    });
  }

  return "${BitpackProvider.of(context).settings.apiBase}/$path$queryString";
}

String colorToString(Color color) {
  return "rgb(${color.red},${color.green},${color.blue})";
}

String buildUrl(
  BuildContext context,
  String url, {
  BitpackImageOptions? options,
}) {
  final Map<String, dynamic> params = {};

  if (options != null) {
    final width = options.width;
    final height = options.height;
    final fit = options.fit;
    final grayscale = options.grayscale;
    final tint = options.tint;
    final background = options.background;
    final flip = options.flip;
    final flop = options.flop;
    final negate = options.negate;

    if (width != null) {
      params['width'] = width.floor();
    }

    if (height != null) {
      params['height'] = height.floor();
    }

    if (fit != null) {
      String fitValue = "";
      switch (fit) {
        case BoxFit.contain:
          fitValue = "contain";
          break;
        case BoxFit.cover:
          fitValue = "cover";
          break;
        default:
          fitValue = "contain";
          break;
      }
      params['fit'] = fitValue;
    }

    if (grayscale) {
      params['grayscale'] = true;
    }

    if (tint != null) {
      params['tint'] = colorToString(tint);
    }

    if (background != null) {
      params['background'] = colorToString(background);
    }

    if (flip) {
      params['flip'] = true;
    }

    if (flop) {
      params['flop'] = true;
    }

    if (negate) {
      params['negate'] = true;
    }
  }

  return queryStringUrl(context, url, params);
}
