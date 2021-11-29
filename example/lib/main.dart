import 'package:flutter/material.dart';
import "config.dart" as config;
import "package:bitpack_flutter/bitpack_flutter.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BitpackProvider(
      apiBase: config.apiBase,
      applicationName: config.applicationName,
      apiKey: config.apiKey,
      child: MaterialApp(
        title: 'bitpack example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const UploadPage(),
      ),
    );
  }
}

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  void _handleChange(String? url) {
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Screen"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const PreviewPage(),
                ),
              );
            },
            icon: const Icon(Icons.preview),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              height: 250,
              child: BitpackImageUploader(
                aspectRatio: 0.5,
                onChanged: _handleChange,
              ),
            ),
            const Divider(),
            const Text("Custom Implementation"),
            ElevatedButton(
              onPressed: () async {
                final service =
                    BitpackService(BitpackProvider.of(context).settings);

                final result = await service.chooseImage();

                print(result);
              },
              child: const Text("Upload"),
            )
          ],
        ),
      ),
    );
  }
}

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool _grayscale = false;
  bool _negate = false;
  bool _flip = false;
  bool _flop = false;
  bool _shouldCover = true;

  Color? _tint;
  Color? _background;

  final colors = [
    null,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Screen"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const UploadPage(),
                ),
              );
            },
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            BitpackImage(
              path:
                  "asset/capsul-dev/image/82fdff2e-8f0e-4bc7-bc8f-251ad32352e5.jpg",
              width: 250,
              height: 250,
              options: BitpackImageOptions(
                width: 500,
                height: 500,
                fit: _shouldCover ? BoxFit.cover : BoxFit.contain,
                tint: _tint,
                grayscale: _grayscale,
                flip: _flip,
                flop: _flop,
                negate: _negate,
                background: _background,
              ),
            ),
            const Divider(),
            _Checkbox(
              label: "Cover",
              value: _shouldCover,
              onChanged: (value) {
                setState(() {
                  _shouldCover = value;
                });
              },
            ),
            _Checkbox(
              label: "Grayscale",
              value: _grayscale,
              onChanged: (value) {
                setState(() {
                  _grayscale = value;
                });
              },
            ),
            _Checkbox(
              label: "Negate",
              value: _negate,
              onChanged: (value) {
                setState(() {
                  _negate = value;
                });
              },
            ),
            _Checkbox(
              label: "Flip",
              value: _flip,
              onChanged: (value) {
                setState(() {
                  _flip = value;
                });
              },
            ),
            _Checkbox(
              label: "Flop",
              value: _flop,
              onChanged: (value) {
                setState(() {
                  _flop = value;
                });
              },
            ),
            const Text(
              "Tint",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _tint = c;
                        });
                      },
                      child: Opacity(
                        opacity: _tint == c ? 1 : 0.5,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c ?? Colors.transparent,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              "Background",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _background = c;
                        });
                      },
                      child: Opacity(
                        opacity: _background == c ? 1 : 0.5,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c ?? Colors.transparent,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      title: Text(label),
      onChanged: (value) {
        onChanged(value ?? false);
      },
    );
  }
}
