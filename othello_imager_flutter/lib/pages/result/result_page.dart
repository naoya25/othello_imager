import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:othello_imager_flutter/components/othello_image.dart';
import 'package:othello_imager_flutter/components/preview_board.dart';
import 'package:othello_imager_flutter/pages/result/result_page_provider.dart';
import 'package:path_provider/path_provider.dart';

class ResultPage extends ConsumerWidget {
  final int playerScore;
  final int computerScore;
  final List<List<int>> board;

  const ResultPage({
    super.key,
    required this.playerScore,
    required this.computerScore,
    required this.board,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultPageNotifier = ref.read(resultPageNotifierProvider.notifier);
    final GlobalKey repaintBoundaryKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ゲーム終了'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('あなたのスコア: $playerScore'),
              Text('コンピュータのスコア: $computerScore'),
              PreviewBoard(board: board),
              ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: const Text('ホームに戻る'),
              ),
              RepaintBoundary(
                key: repaintBoundaryKey,
                child: OthelloImage(board: board),
              ),
              TextButton(
                onPressed: () async {
                  await _saveImage(repaintBoundaryKey);
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage(GlobalKey repaintBoundaryKey) async {
    try {
      // RepaintBoundary の RenderObject を取得
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
