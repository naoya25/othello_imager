import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:othello_imager_flutter/components/preview_board.dart';
import 'package:othello_imager_flutter/pages/play/play_page_provider.dart';
import 'package:othello_imager_flutter/pages/result/result_page.dart';
import 'package:othello_imager_flutter/utils/constants.dart';

class PlayPage extends ConsumerWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(playPageNotifierProvider);
    final playPageNotifier = ref.read(playPageNotifierProvider.notifier);

    void handleTapTile(int i, int j) {
      final newBoard = playPageNotifier.updateBoard(
        i,
        j,
        ConstantValue.playerUser,
      );

      if (newBoard != null) {
        // スコア計算と結果画面への遷移
        final playerScore = playPageNotifier.calcScore(
          newBoard,
          ConstantValue.playerUser,
        );
        final computerScore = playPageNotifier.calcScore(
          newBoard,
          ConstantValue.playerCp,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              playerScore: playerScore,
              computerScore: computerScore,
              board: newBoard,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('オセロイメージャー'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: board.when(
        data: (board) {
          return Column(
            children: [
              const Text('あなたは白です'),
              PreviewBoard(board: board, onTapTile: handleTapTile),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
