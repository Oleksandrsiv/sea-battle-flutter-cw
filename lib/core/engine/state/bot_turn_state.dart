import 'package:sea_battle_cw/core/engine/state/state.dart';
//import 'package:sea_battle_cw/core/patterns/state/state.dart';
import '../../engine/game_engine.dart';
//import '../template-method/bot_class.dart';
//import '../../patterns/template-method/bot_class.dart';
import '../template-method/bot_class.dart';
import 'game_over_state.dart';

class BotTurnState implements GameState {
  @override
  String get stateName => "Хід супротивника...";

  @override
  void handleTap(GameEngine engine, int x, int y) {
    // Класика: ігноруємо панічні кліки гравця
    print("Зачекайте, зараз думає бот. Ваш клік по [$x, $y] проігноровано.");
  }

  @override
  Future<void> onEnter(GameEngine engine) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // start a bot turn action
    var action = BotTurnAction(engine, engine.playerBoard, engine.botStrategy);
    action.executeTurn();

    // check if game is over after bot's turn
    if (!engine.playerBoard.hasMultiDeckShipsAlive()) {
      engine.changeState(GameOverState("Бот переміг. Флот знищено."));
    } else if (engine.currentStateName == stateName) {

      onEnter(engine);
    }
  }
}