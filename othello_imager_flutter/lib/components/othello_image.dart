import 'package:flutter/material.dart';
import 'package:othello_imager_flutter/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OthelloImage extends StatelessWidget {
  final List<List<int>> board;
  final AsyncValue<String?> imageUrl;
  final Future<void> Function() doRetry;
  final double w;

  const OthelloImage({
    super.key,
    required this.board,
    required this.imageUrl,
    required this.doRetry,
    this.w = 300,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl.when(
      data: (url) => url != null
          ? _othelloImage(url)
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

  Widget _othelloImage(String url) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: url,
            height: w,
            width: w,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
