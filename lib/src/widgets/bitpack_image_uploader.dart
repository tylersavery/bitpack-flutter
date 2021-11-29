import 'package:bitpack_flutter/bitpack_flutter.dart';
import 'package:flutter/material.dart';

class BitpackImageUploader extends StatefulWidget {
  const BitpackImageUploader({
    Key? key,
    required this.onChanged,
    this.initialUrl,
    this.aspectRatio = 1.0,
    this.chooseText = "Choose Image",
    this.replaceText = "Replace Image",
  }) : super(key: key);

  final Function(String?) onChanged;
  final String? initialUrl;
  final double aspectRatio;
  final String chooseText;
  final String replaceText;

  @override
  State<BitpackImageUploader> createState() => _BitpackImageUploaderState();
}

class _BitpackImageUploaderState extends State<BitpackImageUploader> {
  String? _path;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _path = widget.initialUrl;
  }

  Future<void> _handleChoose(settings) async {
    setState(() {
      _loading = true;
    });

    final service = BitpackService(settings);
    final url = await service.chooseImage();

    widget.onChanged(url);

    setState(() {
      _path = url;
      _loading = false;
    });
  }

  void _handleRemove() {
    widget.onChanged(null);
    setState(() {
      _path = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_path != null) {
      return AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _handleChoose(BitpackProvider.of(context).settings);
                  },
                  child: BitpackImage(
                    path: _path!,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: _handleRemove,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.delete),
                        )),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        widget.replaceText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      );
    }

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        _handleChoose(BitpackProvider.of(context).settings);
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.black12),
        child: Center(
          child: Text(
            widget.chooseText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
