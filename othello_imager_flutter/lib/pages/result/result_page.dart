import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:othello_imager_flutter/components/othello_image.dart';
import 'package:othello_imager_flutter/components/preview_board.dart';
import 'package:othello_imager_flutter/pages/result/result_page_provider.dart';

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
                  await resultPageNotifier.saveImage(repaintBoundaryKey);
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
