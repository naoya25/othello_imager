import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:othello_imager_flutter/pages/home/home_page.dart';
import 'package:othello_imager_flutter/pages/play/play_page.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/play',
      name: 'play',
      builder: (context, state) {
        return const PlayPage();
      },
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) {
        return const PlayPage();
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
