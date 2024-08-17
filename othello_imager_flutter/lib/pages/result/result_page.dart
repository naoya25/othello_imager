import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:othello_imager_flutter/components/preview_board.dart';

class ResultPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ゲーム終了'),
      ),
      body: Center(
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
          ],
        ),
      ),
    );
  }
}
