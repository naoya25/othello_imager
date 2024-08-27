import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:othello_imager_flutter/utils/images.dart';
import 'package:othello_imager_flutter/utils/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:http/http.dart' as http;

part 'result_page_provider.g.dart';

@Riverpod(keepAlive: true)
class ResultPageNotifier extends _$ResultPageNotifier {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  // Future<String> rep(String prompt) async {
  //   const apiKey = '*******************';
  //   final url = Uri.parse('https://api.openai.com/v1/images/generations');

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $apiKey',
  //     },
  //     body: jsonEncode({
  //       "model": "dall-e-3",
  //       "prompt": prompt,
  //       "response_format": 'b64_json',
  //       "n": 1,
  //       "size": "1024x1024",
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final imageUrl = data['data'][0]['url'];
  //     return imageUrl;
  //   } else {
  //     throw Exception('Failed to generate image');
  //   }
  // }

  Future<void> generateImage() async {
    state = const AsyncValue.loading();

    try {
      // final b64image = await rep('猫');
      // print(b64image);
      final b64image = await convertImageToBase64('assets/images/test.webp');
      state = AsyncValue.data(b64image);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> saveImage(
    GlobalKey repaintBoundaryKey,
    BuildContext context,
  ) async {
    try {
      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // キャプチャを画像化
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // ファイルに保存
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/othello_image.png';
      final File imgFile = File(filePath);
      await imgFile.writeAsBytes(pngBytes);

      if (!context.mounted) return;
      showSnackBar(
        context: context,
        message: '画像が保存されました: $filePath',
        duration: const Duration(minutes: 3),
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: '画像保存中にエラーが発生しました: $e',
        duration: const Duration(minutes: 3),
      );
    }
  }
}
