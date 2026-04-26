import 'package:flutter/material.dart';

import '../../core/engine/game_engine.dart';
import '../../core/engine/observer/observer.dart';



class GameController extends ChangeNotifier implements IGameSubscriber {
  final GameEngine engine;

  GameController({required this.engine}) {
    engine.subscribe(this);
  }

  // This method is called by the GameEngine whenever something changes in the game state,
  // by calling notifySubscribers() inside the engine.
  @override
  void update() {
    notifyListeners();
  }

  void handleTap(int x, int y) {
    engine.handleCellTap(x, y);
  }

  @override
  void dispose() {
    engine.unsubscribe(this);
    super.dispose();
  }

}