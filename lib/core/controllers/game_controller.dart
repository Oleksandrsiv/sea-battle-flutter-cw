import 'package:flutter/material.dart';

import '../../core/engine/game_engine.dart';
import '../../core/engine/observer/observer.dart';
import '../engine/state/setup_state.dart';



class GameController extends ChangeNotifier implements IGameSubscriber {
  final GameEngine engine;

  GameController({required this.engine}) {
    engine.subscribe(this);
  }

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

  void undo() {
    if (engine.currentState is SetupState) {
      final setupState = engine.currentState as SetupState;
      setupState.undoLast();

      notifyListeners();
    }
  }

}