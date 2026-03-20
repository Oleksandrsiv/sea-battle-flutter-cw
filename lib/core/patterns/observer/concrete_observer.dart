import 'dart:developer';

import '../../engine/game_engine.dart';
import 'observer.dart';

// [ConcreteObserver]
class UIController implements IGameSubscriber {
  // STORES REFERENCE to ConcreteSubject
  final GameEngine _engine;

  // We get this reference through the constructor
  UIController(this._engine);

  @override
  void update() {
    int currentX = _engine.lastX;
    int currentY = _engine.lastY;
    var currentStatus = _engine.lastStatus;
    
    log('UI Redrawn! Extracted data: Cell [$currentX, $currentY] now $currentStatus');
  }
}
