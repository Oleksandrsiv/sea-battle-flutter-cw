import 'package:sea_battle_cw/core/patterns/state/state.dart';

import '../../engine/game_engine.dart';


class SetupState implements GameState {
  @override
  String get stateName => "Розстановка флоту";

  @override
  void handleTap(GameEngine engine, int x, int y) {
    print("Ставимо корабель на координати [$x, $y]...");
    // TODO: Тут буде логіка ручної розстановки.

    // Для тесту: уявимо, що ми поставили всі кораблі, і перемикаємо гру на бій
    print("Всі кораблі розставлено! Починаємо бій.");
    engine.changeState(PlayerTurnState());
  }
}

// [ConcreteState 2] - Хід гравця
class PlayerTurnState implements GameState {
  @override
  String get stateName => "Ваш хід!";

  @override
  void handleTap(GameEngine engine, int x, int y) {
    print("Гравець стріляє у клітинку [$x, $y]...");

    // Логіка пострілу (викликаємо її з движка)
    bool isHit = engine.processShot(x, y);

    if (isHit) {
      print("Влучання! Ви стріляєте ще раз.");
      // Стан НЕ змінюємо, гравець продовжує
    } else {
      print("Промах. Хід переходить до бота.");
      engine.changeState(BotTurnState());
    }
  }
}

// [ConcreteState 3] - Хід бота
class BotTurnState implements GameState {
  @override
  String get stateName => "Хід супротивника...";

  @override
  void handleTap(GameEngine engine, int x, int y) {
    // Якщо зараз хід бота, ми просто ІГНОРУЄМО кліки гравця по екрану!
    print("Зачекайте, зараз думає бот. Ваш клік по [$x, $y] проігноровано.");

    // TODO: Пізніше тут будемо викликати шаблон Strategy для алгоритму бота.
    // А поки для тесту просто повертаємо хід гравцю.
    engine.changeState(PlayerTurnState());
  }
}

// [ConcreteState 4] - Кінець гри
class GameOverState implements GameState {
  @override
  String get stateName => "Гра завершена";

  @override
  void handleTap(GameEngine engine, int x, int y) {
    print("Гра закінчилась. Натисніть кнопку 'Нова гра' в меню.");
  }
}