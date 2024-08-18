import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'result_page_provider.g.dart';

@riverpod
class ResultPageNotifier extends _$ResultPageNotifier {
  @override
  ResultPageNotifier build() {
    return this;
  }

  Future<void> saveImage(GlobalKey repaintBoundaryKey) async {
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

      print('画像が保存されました: $filePath');
    } catch (e) {
      print('画像保存中にエラーが発生しました: $e');
    }
  }
}
