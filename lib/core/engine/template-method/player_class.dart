import 'dart:developer';

import '../../../models/cell.dart';
import '../state/bot_turn_state.dart';
import 'turn_action.dart';

class PlayerTurnAction extends TurnAction {
  final int clickX;
  final int clickY;

  PlayerTurnAction(super.engine, super.targetBoard, this.clickX, this.clickY);

  @override
  (int, int)? getCoordinates() {
    // check if click is within board boundaries and if cell was not already targeted
    if (!targetBoard.isValidCoordinates(clickX, clickY)) return null;
    var status = targetBoard.grid[clickY][clickX].status;
    if (status == CellStatus.miss || status == CellStatus.hit || status == CellStatus.sunk) {
      return null; // this cell was already targeted, player should click somewhere else
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