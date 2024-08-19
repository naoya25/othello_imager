import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:othello_imager_flutter/main.dart';
import 'package:othello_imager_flutter/utils/snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'result_page_provider.g.dart';

@Riverpod(keepAlive: true)
class ResultPageNotifier extends _$ResultPageNotifier {
  @override
  FutureOr<String?> build() async {
    return null;
  }

  Future<void> generateImage() async {
    state = const AsyncValue.loading();

    try {
      final url = await client.openAiService.generateImage('猫');
      state = AsyncValue.data(url);
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
