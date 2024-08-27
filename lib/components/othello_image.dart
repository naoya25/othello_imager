import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:othello_imager_flutter/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class OthelloImage extends StatelessWidget {
  final List<List<int>> board;
  final AsyncValue<String?> b64image;
  final Future<void> Function() doRetry;
  final double w;

  const OthelloImage({
    super.key,
    required this.board,
    required this.b64image,
    required this.doRetry,
    this.w = 350,
  });

  @override
  Widget build(BuildContext context) {
    return b64image.when(
      data: (b64) => b64 != null
          ? _othelloImage(b64)
          : TextButton(
              onPressed: () async {
                await doRetry();
              },
              child: const Text('リトライ'),
            ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Column(
        children: [
          Text('Error: $error'),
          TextButton(
            onPressed: () async {
              await doRetry();
            },
            child: const Text('リトライ'),
          ),
        ],
      ),
    );
  }

  Widget _othelloImage(String b64) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.memory(
            base64Decode(b64),
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
              for (int i = 0; i < ConstantValue.othelloSize; i++)
                Row(
                  children: [
                    for (int j = 0; j < ConstantValue.othelloSize; j++)
                      Container(
                        color: _getTileColor(board[i][j]),
                        height: w / ConstantValue.othelloSize,
                        width: w / ConstantValue.othelloSize,
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
