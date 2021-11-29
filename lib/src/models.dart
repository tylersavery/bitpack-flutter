import 'package:flutter/material.dart';

class BitpackSettings {
  final String apiBase;
  final String applicationName;
  final String apiKey;

  const BitpackSettings({
    required this.apiBase,
    required this.applicationName,
    required this.apiKey,
  });
}

class BitpackResponse {
  final String url;
  final Map<String, dynamic> fields;
  final bool exists;

  BitpackResponse({
    required this.url,
    required this.fields,
    required this.exists,
  });

  factory BitpackResponse.fromJson(Map<String, dynamic> json) {
    return BitpackResponse(
      url: json['url'],
      fields: json['fields'],
      exists: json['exists'],
    );
  }

  String get key {
    return fields['key'];
  }
}

class BitpackImageOptions {
  const BitpackImageOptions({
    this.width,
    this.height,
    this.fit,
    this.grayscale = false,
    this.tint,
    this.background,
    this.negate = false,
    this.flip = false,
    this.flop = false,
  });

  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool grayscale;
  final Color? tint;
  final Color? background;
  final bool negate;
  final bool flip;
  final bool flop;
}
