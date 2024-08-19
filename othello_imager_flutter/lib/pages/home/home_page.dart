import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:othello_imager_flutter/pages/result/result_page_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultPageNotifier = ref.read(resultPageNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('オセロイメージャー'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            context.push('/play');

            // 画像の事前生成 & 事前キャッシュ
            await resultPageNotifier.generateImage();
            final imageUrl = ref.watch(resultPageNotifierProvider);
            if (context.mounted) {
              imageUrl.whenData((url) async {
                if (url != null && context.mounted) {
                  await precacheImage(NetworkImage(url), context);
                }
              });
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'ゲーム開始',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
