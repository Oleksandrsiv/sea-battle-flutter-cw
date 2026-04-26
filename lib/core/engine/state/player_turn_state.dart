import 'dart:developer';

import 'package:sea_battle_cw/core/engine/state/state.dart';
//import 'package:sea_battle_cw/core/patterns/state/state.dart';

import '../../engine/game_engine.dart';
//import '../../patterns/template-method/player_class.dart';
//import '../template-method/player_class.dart';
import '../template-method/player_class.dart';
import 'game_over_state.dart';

class PlayerTurnState implements GameState {
  @override
  String get stateName => "Your turn!";

  @override
  void onEnter(GameEngine engine) {}

  @override
  void handleTap(GameEngine engine, int x, int y) {
    log("player shoot at [$x, $y]...");

    var action = PlayerTurnAction(engine, engine.botBoard, x, y);
    action.executeTurn();

    // check if the game is over after the player's shot
    if (!engine.botBoard.hasMultiDeckShipsAlive() /* && перевірка на однопалубні, потім вирішу чи треба */) {
      engine.changeState(GameOverState("You win!"));
    }
  }
}