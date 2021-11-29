import 'dart:convert';
import 'dart:async';

import 'dart:io';
import 'package:bitpack_flutter/src/models.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class BitpackService {
  BitpackService(BitpackSettings settings) {
    apiBase = settings.apiBase;
    applicationName = settings.applicationName;
    apiKey = settings.apiKey;
  }

  late String apiBase;
  late String applicationName;
  late String apiKey;

  Map<String, String> get _headers {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      'X-API-KEY': apiKey
    };
  }

  Future<bool> _uploadToS3(BitpackResponse bpr, File file) async {
    try {
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();

      final request = http.MultipartRequest("POST", Uri.parse(bpr.url));

      for (final entry in bpr.fields.entries) {
        request.fields[entry.key] = entry.value;
      }

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
      );

      request.files.add(multipartFile);
      final response = await request.send();

      await response.stream.bytesToString();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<BitpackResponse?> _initImage({
    String? path,
    String contentType = "image/jpeg",
    String ext = 'jpg',
  }) async {
    final payload = {
      'content_type': contentType,
      'path': path ?? const Uuid().v4().toString() + "." + ext,
    };

    try {
      final response = await http.post(
        Uri.parse("$apiBase/asset/$applicationName/image/"),
        body: json.encode(payload),
        headers: _headers,
      );

      var data = jsonDecode(response.body) as Map<String, dynamic>;

      return BitpackResponse.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> chooseImage({
    ImageSource source = ImageSource.gallery,
    double maxWidth = 1920,
    double maxHeight = 1920,
    int? quality,
    String? path,
  }) async {
    try {
      final ImagePicker _picker = ImagePicker();

      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      final file = File(pickedFile!.path);

      final data = await _initImage(
        path: path,
        contentType: "image/jpeg",
        ext: "jpg",
      );

      if (data == null) {
        return null;
      }

      final success = await _uploadToS3(data, file);

      if (success) {
        await Future.delayed(const Duration(seconds: 3));
        return data.key;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
