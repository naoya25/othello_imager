import 'dart:convert';

import 'package:flutter/services.dart';

Future<String> convertImageToBase64(String assetPath) async {
  ByteData byteData = await rootBundle.load(assetPath);
  Uint8List imageBytes = byteData.buffer.asUint8List();

  String base64String = base64Encode(imageBytes);
  return base64String;
}
