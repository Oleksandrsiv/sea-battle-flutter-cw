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

   Ship getShip() => _ship;

   @override
   bool execute() { // Обов'язково bool!
     if (_board.canPlaceShip(_x, _y, _ship.size, _ship.isHorizontal)) {
       _board.placeShip(_ship, _x, _y);
       log("Команда виконана: корабель розміщено на [$_x, $_y].");
       return true; // Повертаємо успіх
     } else {
       log("Команда не виконана: місце зайняте.");
       return false; // Повертаємо невдачу
     }
   }

  @override
  void undo() {
    _board.removeShip(_x, _y);
    log("Команда скасована: корабель видалено з [$_x, $_y].");
  }
}