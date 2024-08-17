import 'package:flutter/material.dart';
import 'package:othello_imager_flutter/gen/assets.gen.dart';
import 'package:othello_imager_flutter/utils/constants.dart';

class OthelloImage extends StatelessWidget {
  final List<List<int>> board;
  final double w;
  const OthelloImage({
    super.key,
    required this.board,
    this.w = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Assets.images.test.image(
            height: w,
            width: w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: w,
          height: w,
          child: Column(
            children: [
              for (int i = 0; i < 8; i++)
                Row(
                  children: [
                    for (int j = 0; j < 8; j++)
                      Container(
                        color: _getTileColor(board[i][j]),
                        height: w / 8,
                        width: w / 8,
                      )
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }

  Color? _getTileColor(int value) {
    switch (value) {
      case ConstantValue.playerUser:
        return null;
      default:
        return Colors.black;
    }
  }
}
