import 'package:flutter/material.dart';
import 'package:othello_imager_flutter/utils/constants.dart';

class PreviewBoard extends StatelessWidget {
  final List<List<int>> board;
  final void Function(int i, int j)? onTapTile;

  const PreviewBoard({
    super.key,
    required this.board,
    this.onTapTile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < ConstantValue.othelloSize; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int j = 0; j < ConstantValue.othelloSize; j++)
                  Container(
                    color: Colors.green,
                    margin: const EdgeInsets.all(1),
                    child: GestureDetector(
                      onTap: () {
                        if (onTapTile != null) onTapTile!(i, j);
                      },
                      child: Container(
                        width: 320 / ConstantValue.othelloSize,
                        height: 320 / ConstantValue.othelloSize,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _getTileColor(board[i][j]),
                          shape: board[i][j] == ConstantValue.playerEmpty
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Color? _getTileColor(int value) {
    switch (value) {
      case ConstantValue.playerCp:
        return Colors.black;
      case ConstantValue.playerUser:
        return Colors.white;
      default:
        return null;
    }
  }
}
