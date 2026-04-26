

import 'dart:math';

import 'package:sea_battle_cw/core/ai/strategy/i_bot_strategy.dart';
//import 'package:sea_battle_cw/core/patterns/strategy/i_bot_strategy.dart';
import 'package:sea_battle_cw/models/board.dart';

import '../../../models/cell.dart';

class RandomHuntStrategy implements IBotStrategy {
  final Random _random = Random();

  @override
  (int, int) calculateNextShot(Board targetBoard) {
    List<(int, int)> availableCells = [];

    // ask the board if there are still multi-deck ships alive
    bool useCheckerboard = targetBoard.hasMultiDeckShipsAlive();

    for (int y = 0; y < targetBoard.size; y++) {
      for (int x = 0; x < targetBoard.size; x++) {
        var status = targetBoard.grid[y][x].status;

        if (status == CellStatus.water || status == CellStatus.ship) {
          if (useCheckerboard) {
            // search for checkerboard pattern: only cells where (x + y) is even
            if ((x + y) % 2 == 0) {
              availableCells.add((x, y));
            }
          } else {
            // search when only single-deck ships are left: all cells are valid
            availableCells.add((x, y));
          }

        }
      }
    }

    // guard against errors: if for some reason we ended up with no available cells (shouldn't happen, but just in case)
    if (availableCells.isEmpty) {
      print('Warning: Checkerboard cells exhausted, searching everywhere.');
      return _emergencyFallback(targetBoard);
    }

    // randomly select one of the available cells
    int randomIndex = _random.nextInt(availableCells.length);
    return availableCells[randomIndex];
  }

  // emergency fallback in case something goes wrong
  (int, int) _emergencyFallback(Board targetBoard) {
    for (int y = 0; y < targetBoard.size; y++) {
      for (int x = 0; x < targetBoard.size; x++) {
        var status = targetBoard.grid[y][x].status;
        if (status == CellStatus.water || status == CellStatus.ship) {
          return (x, y);
        }
      }
    }
    return (0, 0);
  }
}
