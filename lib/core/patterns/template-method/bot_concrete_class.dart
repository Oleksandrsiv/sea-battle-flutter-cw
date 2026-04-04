import 'dart:developer';

import '../state/concrete_player_turn_state.dart';
import '../strategy/strategy.dart';
import 'abstract_class.dart';

class BotTurnAction extends TurnAction {
  final IBotStrategy currentStrategy;

  BotTurnAction(super.engine, super.targetBoard, this.currentStrategy);

  @override
  (int, int)? getCoordinates() {
    return currentStrategy.calculateNextShot(targetBoard);
  }

  @override
  void afterShot(bool isHit, int x, int y) {
    engine.updateBotStrategy(isHit, x, y);

    if (!isHit) {
      log("Bot missed at [$x, $y]. Player's turn.");
      engine.changeState(PlayerTurnState());
    } else {
      log("Bot hit at [$x, $y]! Bot's turn continues.");
    }
  }
}