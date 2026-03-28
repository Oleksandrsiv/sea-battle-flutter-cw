import 'dart:developer';

import '../state/concrete_player_turn_state.dart';
import '../strategy/strategy.dart';
import 'abstract_class.dart';

class BotTurnAction extends TurnAction {
  final IBotStrategy currentStrategy;

  BotTurnAction(super.engine, super.targetBoard, this.currentStrategy);

  @override
  (int, int)? getCoordinates() {
    // Бот бере координати зі своєї поточної стратегії,
    // передаючи їй дошку гравця (targetBoard) для аналізу.
    return currentStrategy.calculateNextShot(targetBoard);
  }

  @override
  void afterShot(bool isHit, int x, int y) {
    // Якщо бот влучив, ми повинні змінити його стратегію на Probe або Destroy.
    // Оскільки твої стратегії живуть окремо, ми передамо цю задачу в GameEngine
    // або в стан BotTurnState (бо саме вони керують тим, яка стратегія зараз активна).

    // Повідомляємо двигун про результат, щоб він міг оновити активну стратегію
    engine.updateBotStrategy(isHit, x, y);

    if (!isHit) {
      log("Bot missed at [$x, $y]. Player's turn.");
      engine.changeState(PlayerTurnState());
    } else {
      log("Bot hit at [$x, $y]! Bot's turn continues.");
      // Оскільки стан не змінюється (залишається BotTurnState),
      // треба якось "пнути" бота вистрілити ще раз.
      // Зазвичай це робиться через затримку (Future.delayed) в UI або в самому State.
    }
  }
}