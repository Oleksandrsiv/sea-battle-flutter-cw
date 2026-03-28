// lib/core/patterns/template_method/turn_action.dart

import '../../../models/board.dart';
import '../../engine/game_engine.dart';


/// Абстрактний клас (Скелет алгоритму)
abstract class TurnAction {
  final GameEngine engine;
  final Board targetBoard;

  TurnAction(this.engine, this.targetBoard);

  /// Шаблонний метод. Визначає жорстку послідовність ходу.
  void executeTurn() {
    // 1. Отримуємо координати для пострілу (реалізують спадкоємці)
    final target = getCoordinates();

    // Якщо координат немає (наприклад, гравець не зробив клік), просто виходимо
    if (target == null) return;

    // 2. Робимо постріл по дошці (Спільна логіка)
    // Використовуємо твій готовий метод receiveShot з класу Board!
    bool isHit = targetBoard.receiveShot(target.$1, target.$2);

    // Оновлюємо внутрішні дані двигуна для UI (твої lastX, lastY, lastStatus)
    engine.recordLastShot(target.$1, target.$2, targetBoard.grid[target.$2][target.$1].status);

    // 3. Обробляємо результат пострілу (реалізують спадкоємці)
    afterShot(isHit, target.$1, target.$2);

    // Повідомляємо UI про зміни
    engine.notifySubscribers();
  }

  // --- Абстрактні методи (Примітивні операції) ---

  // Повертає Record (int x, int y)
  (int, int)? getCoordinates();

  void afterShot(bool isHit, int x, int y);
}



