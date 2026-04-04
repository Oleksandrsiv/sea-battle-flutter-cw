// lib/core/patterns/template_method/turn_action.dart

import '../../../models/board.dart';
import '../../engine/game_engine.dart';

abstract class TurnAction {
  final GameEngine engine;
  final Board targetBoard;

  TurnAction(this.engine, this.targetBoard);

  void executeTurn() {
    final target = getCoordinates();

    if (target == null) return;

    bool isHit = targetBoard.receiveShot(target.$1, target.$2);

    engine.recordLastShot(target.$1, target.$2, targetBoard.grid[target.$2][target.$1].status);

    afterShot(isHit, target.$1, target.$2);

    engine.notifySubscribers();
  }


  // return Record (int x, int y)
  (int, int)? getCoordinates();

  void afterShot(bool isHit, int x, int y);
}



