import 'package:bitpack_flutter/bitpack_flutter.dart';
import 'package:flutter/material.dart';

class BitpackProvider extends StatefulWidget {
  const BitpackProvider({
    Key? key,
    required this.child,
    required this.apiBase,
    required this.apiKey,
    required this.applicationName,
  }) : super(key: key);

  final Widget child;
  final String apiBase;
  final String applicationName;
  final String apiKey;

  @override
  State<BitpackProvider> createState() => _BitpackProviderState();

  static BitpackProvider of(BuildContext context) {
    final result = context.findAncestorStateOfType<_BitpackProviderState>();
    return result!.widget;
  }

  BitpackSettings get settings {
    return BitpackSettings(
      apiBase: apiBase,
      applicationName: applicationName,
      apiKey: apiKey,
    );
  }
}

class _BitpackProviderState extends State<BitpackProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
