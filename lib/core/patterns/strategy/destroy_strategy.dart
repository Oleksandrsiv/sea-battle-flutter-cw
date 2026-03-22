import 'dart:developer';

import 'package:sea_battle_cw/core/patterns/strategy/strategy.dart';
import '../../../models/board.dart';
import '../../../models/cell.dart'; // Перевір свій імпорт CellStatus

class DestroyStrategy implements IBotStrategy {
  final int firstHitX;
  final int firstHitY;

  // vectors
  late final int dx;
  late final int dy;


  DestroyStrategy(this.firstHitX, this.firstHitY, int secondHitX, int secondHitY) {
    // that "sign" function will give us the direction of the vector: -1, 0, or 1 for each axis
    dx = (secondHitX - firstHitX).sign;
    dy = (secondHitY - firstHitY).sign;
  }

  @override
  (int x, int y) calculateNextShot(Board targetBoard) {
    log("finishing off ship at [$firstHitX, $firstHitY] with vectors [$dx, $dy]...");

    // 1. go to + direction first
    int step = 1;
    while (true) {
      int nextX = firstHitX + dx * step;
      int nextY = firstHitY + dy * step;

      if (!targetBoard.isValidCoordinates(nextX, nextY)) break;

      var status = targetBoard.grid[nextY][nextX].status;

      if (status == CellStatus.miss || status == CellStatus.sunk) break;

      // if we get here, it means this cell is a hit, so we should continue in this direction
      if (status == CellStatus.hit) {
        step++;
        continue;
      }

      // if we get here, it means this cell is either water or an unhit ship, so we should shoot here
      if (status == CellStatus.water || status == CellStatus.ship) {
        return (nextX, nextY);
      }
    }

    // 2. go to - direction if + direction is exhausted
    step = 1;
    while (true) {
      int nextX = firstHitX - dx * step;
      int nextY = firstHitY - dy * step;

      if (!targetBoard.isValidCoordinates(nextX, nextY)) break;

      var status = targetBoard.grid[nextY][nextX].status;
      if (status == CellStatus.miss || status == CellStatus.sunk) break;

      if (status == CellStatus.hit) {
        step++;
        continue;
      }

      if (status == CellStatus.water || status == CellStatus.ship) {
        return (nextX, nextY);
      }
    }

    // safety fallback: if for some reason we exhausted both directions without finding a valid cell (shouldn't happen, but just in case), we return to the original hit point
    log("Attention: No cells found for finishing off the ship. Returning to the original hit point.");
    return (firstHitX, firstHitY);
  }
}