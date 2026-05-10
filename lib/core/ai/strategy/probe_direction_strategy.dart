
import 'dart:developer';

import 'package:sea_battle_cw/core/ai/strategy/ibot_strategy.dart';

import '../../../models/board.dart';
import '../../../models/cell.dart';

class ProbeDirectionStrategy implements IBotStrategy {
  final int firstHitX;
  final int firstHitY;

  // vectors: (dx, dy)
  // (0, -1) - up, (1, 0) - right, (0, 1) - down, (-1, 0) - left
  final List<(int, int)> _directions = [
    (0, -1),
    (1, 0),
    (0, 1),
    (-1, 0)
  ];

  // variable to keep track of which direction we're currently checking
  int _currentDirectionIndex = 0;

  ProbeDirectionStrategy(this.firstHitX, this.firstHitY);


    @override
    (int x, int y) calculateNextShot(Board targetBoard) {
      log("check direction around point [$firstHitX, $firstHitY]...");

      // cycle needed to check all directions and prevent out-of-bounds errors or shooting at already known cells
      while (_currentDirectionIndex < _directions.length) {
        var (dx, dy) = _directions[_currentDirectionIndex];

        int nextX = firstHitX + dx;
        int nextY = firstHitY + dy;

        _currentDirectionIndex++; // move to the next direction for the next iteration

        if (targetBoard.isValidCoordinates(nextX, nextY)) {
          var status = targetBoard.grid[nextY][nextX].status;

          if (status == CellStatus.water || status == CellStatus.ship) {
            return (nextX, nextY);
          }
        }
      }

      // safety fallback:
      // if all directions are exhausted, we return to the original hit point
      log("Attention: All directions around the first hit are exhausted. Returning to the original hit point.");
      return (firstHitX, firstHitY);
    }
  }