import 'package:sea_battle_cw/core/engine/state/state.dart';
import '../../engine/game_engine.dart';
import '../template-method/bot_class.dart';
import 'game_over_state.dart';

class BotTurnState implements GameState {
  @override
  String get stateName => "Enemy`s turn...";

  @override
  void handleTap(GameEngine engine, int x, int y) {
    print("Wait, the bot is thinking. Your click on [$x, $y] is ignored.");
  }

  @override
  Future<void> onEnter(GameEngine engine) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // start a bot turn action
    var action = BotTurnAction(engine, engine.playerBoard, engine.botStrategy);
    action.executeTurn();

    // check if game is over after bot's turn
    if (!engine.playerBoard.hasAliveShips()) {
      engine.changeState(GameOverState("Bot wins. Fleet destroyed."));
    } else if (engine.currentStateName == stateName) {

      await onEnter(engine);
    }
  }
}