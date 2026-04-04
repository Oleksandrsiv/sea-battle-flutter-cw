import 'package:flutter/material.dart';

import '../../core/engine/game_engine.dart';
import '../../core/patterns/observer/observer.dart';

// 1. Успадковуємо ChangeNotifier (щоб Flutter вмів його слухати)
// 2. Імплементуємо IGameSubscriber (щоб GameEngine міг йому кричати)
class GameController extends ChangeNotifier implements IGameSubscriber {
  final GameEngine engine;

  // Через конструктор ми отримуємо наш готовий рушій гри
  GameController({required this.engine}) {
    // Відразу підписуємося на його оновлення!
    engine.subscribe(this);
  }

  // Цей метод викликається зсередини GameEngine (патерн Observer)
  @override
  void update() {
    // Коли ядро каже "Я змінилося!", ми перекладаємо це мовою Flutter:
    // notifyListeners() змушує всі віджети, які підписані на цей контролер, перемалюватися.
    notifyListeners();
  }

  // Хороша практика: якщо контролер колись знищиться, треба відписатися, щоб не було витоку пам'яті
  @override
  void dispose() {
    engine.unsubscribe(this);
    super.dispose();
  }
}