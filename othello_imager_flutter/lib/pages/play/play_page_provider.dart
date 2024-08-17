import 'dart:math';

import 'package:othello_imager_flutter/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'play_page_provider.g.dart';

@riverpod
class PlayPageNotifier extends _$PlayPageNotifier {
  @override
  FutureOr<List<List<int>>> build() async {
    return _initializeBoard();
  }

  // ボードの初期化
  List<List<int>> _initializeBoard() {
    return List.generate(
      8,
      (i) => List.generate(
        8,
        (j) {
          if ((i == 3 && j == 3) || (i == 4 && j == 4)) {
            return ConstantValue.playerUser;
          } else if ((i == 3 && j == 4) || (i == 4 && j == 3)) {
            return ConstantValue.playerCp;
          } else {
            return ConstantValue.playerEmpty;
          }
        },
      ),
    );
  }

  // ボードの更新
  List<List<int>>? updateBoard(int x, int y, int player) {
    if (!_isValidMove(x, y, player)) return null;

    state = state.whenData(
      (currentBoard) {
        List<List<int>> newBoard = _deepCopyBoard(currentBoard);
        _flipDiscs(x, y, player, newBoard);
        newBoard[x][y] = player;
        return newBoard;
      },
    );

    if (player == ConstantValue.playerUser) {
      _computerMove();
    }
    if (_isGameOver(state.value!)) {
      return state.value;
    }
    return null;
  }

  List<List<int>> _deepCopyBoard(List<List<int>> board) {
    return [
      for (int i = 0; i < board.length; i++)
        [for (int j = 0; j < board[i].length; j++) board[i][j]]
    ];
  }

  // 挟まれてるやつひっくり返す
  void _flipDiscs(int x, int y, int player, List<List<int>> board) {
    for (var dir in ConstantValue.directions) {
      int i = x + dir[0];
      int j = y + dir[1];
      List<List<int>> toFlip = [];

      while (_isWithinBounds(i, j) &&
          board[i][j] != player &&
          board[i][j] != ConstantValue.playerEmpty) {
        toFlip.add([i, j]);
        i += dir[0];
        j += dir[1];
      }

      if (_isWithinBounds(i, j) && board[i][j] == player) {
        for (var pos in toFlip) {
          board[pos[0]][pos[1]] = player;
        }
      }
    }
  }

  bool _isWithinBounds(int i, int j) {
    return i >= 0 && i < 8 && j >= 0 && j < 8;
  }

  // 配置可能か判定
  bool _isValidMove(int x, int y, int player) {
    if (state.value![x][y] != ConstantValue.playerEmpty) return false;

    for (var direction in ConstantValue.directions) {
      int dx = direction[0];
      int dy = direction[1];

      int i = x + dx;
      int j = y + dy;
      bool hasOpponentBetween = false;

      while (_isWithinBounds(i, j)) {
        int current = state.value![i][j];

        if (current == ConstantValue.playerEmpty) {
          break;
        } else if (current != player) {
          hasOpponentBetween = true;
        } else if (hasOpponentBetween) {
          return true;
        } else {
          break;
        }

        i += dx;
        j += dy;
      }
    }

    return false;
  }

  // コンピュータのランダムな動き
  void _computerMove() {
    List<List<int>> validMoves = [];

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (_isValidMove(i, j, ConstantValue.playerCp)) {
          validMoves.add([i, j]);
        }
      }
    }

    if (validMoves.isNotEmpty) {
      final randomMove = validMoves[Random().nextInt(validMoves.length)];
      updateBoard(randomMove[0], randomMove[1], ConstantValue.playerCp);
    }
  }

  bool _isGameOver(List<List<int>> board) {
    bool isFull = board
        .every((row) => row.every((cell) => cell != ConstantValue.playerEmpty));

    bool userHasMove = _playerHasValidMove(ConstantValue.playerUser);
    bool computerHasMove = _playerHasValidMove(ConstantValue.playerCp);

    return isFull || (!userHasMove && !computerHasMove);
  }

  bool _playerHasValidMove(int player) {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (_isValidMove(i, j, player)) {
          return true;
        }
      }
    }
    return false;
  }

  int calcScore(List<List<int>> board, int player) {
    return board.fold(
        0, (sum, row) => sum + row.where((cell) => cell == player).length);
  }
}
