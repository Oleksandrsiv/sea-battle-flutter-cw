// import 'package:sea_battle_cw/core/patterns/state/state.dart';
import 'package:sea_battle_cw/core/engine/state/state.dart';

import '../../engine/game_engine.dart';

class GameOverState implements GameState {
  final String resultMessage;

  GameOverState(this.resultMessage);

  @override
  String get stateName => resultMessage;

  @override
  void onEnter(GameEngine engine) {
    print("Game over: $resultMessage");
  }

  @override
  void handleTap(GameEngine engine, int x, int y) {
    print("Game over. Press 'New game' to play again.");
  }
}