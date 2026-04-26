import 'package:flutter/material.dart';

import '../../core/engine/game_engine.dart';
import '../../core/engine/observer/observer.dart';
//import '../../core/patterns/observer/observer.dart';


class GameController extends ChangeNotifier implements IGameSubscriber {
  final GameEngine engine;

  GameController({required this.engine}) {
    engine.subscribe(this);
  }

  // This method is called by the GameEngine whenever something changes in the game state,
  // by calling notifySubscribers() inside the engine. (Observer pattern)
  @override
  void update() {
    notifyListeners();
  }

  @override
  void dispose() {
    engine.unsubscribe(this);
    super.dispose();
  }
}