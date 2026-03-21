//  concrete_command.dart

import 'dart:developer';
import '../../../models/board.dart';
import '../factory-method/product.dart';
import 'command.dart';

class PlaceShipCommand implements ICommand {

   final Board _board; // Receiver
   final Ship _ship;   // data for command
   final int _x;
   final int _y;

  PlaceShipCommand(this._board, this._ship, this._x, this._y);

  void execute() {
    if (_board.canPlaceShip(_x, _y, _ship.size, _ship.isHorizontal)) {
      _board.placeShip(_ship, _x, _y);
      log("Команда виконана: корабель розміщено на [$_x, $_y].");
      _board.placeShip(_ship, _x, _y);
    } else {
      log("Команда не виконана: неможливо розмістити корабель на [$_x, $_y].");
    }
  }
  void undo() {
    _board.removeShip(_x, _y);
    log("Команда скасована: корабель видалено з [$_x, $_y].");
  }
}