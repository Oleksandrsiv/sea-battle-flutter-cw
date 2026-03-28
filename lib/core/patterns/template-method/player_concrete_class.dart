import 'dart:developer';

import '../../../models/cell.dart';
import '../state/concrete_bot_turn_state.dart';
import 'abstract_class.dart';

class PlayerTurnAction extends TurnAction {
  final int clickX;
  final int clickY;

  PlayerTurnAction(super.engine, super.targetBoard, this.clickX, this.clickY);

  @override
  (int, int)? getCoordinates() {
    // Гравець просто стріляє туди, куди клікнув.
    // Перевіряємо, чи ми вже не стріляли сюди (опціонально, але корисно)
    if (!targetBoard.isValidCoordinates(clickX, clickY)) return null;
    var status = targetBoard.grid[clickY][clickX].status;
    if (status == CellStatus.miss || status == CellStatus.hit || status == CellStatus.sunk) {
      return null; // Сюди вже стріляли, ігноруємо клік
    }

    return (clickX, clickY);
  }

  @override
  void afterShot(bool isHit, int x, int y) {
    if (!isHit) {
      log("Player missed at [$x, $y]. Bot's turn.");
      engine.changeState(BotTurnState());
    } else {
      log("Player hit at [$x, $y]! Player's turn continues.");
    }
  }
}