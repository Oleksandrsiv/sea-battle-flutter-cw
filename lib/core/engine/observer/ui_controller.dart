import 'dart:developer';

import '../../engine/game_engine.dart';
import 'observer.dart';

class UIController implements IGameSubscriber {

  final GameEngine _engine;

  UIController(this._engine);

  @override
  void update() {
    int currentX = _engine.lastX;
    int currentY = _engine.lastY;
    var currentStatus = _engine.lastStatus;
    
    log('UI Redrawn! Extracted data: Cell [$currentX, $currentY] now $currentStatus');
  }
}
