import 'dart:developer';
import 'package:sea_battle_cw/core/engine/state/state.dart';

import '../../engine/game_engine.dart';
import '../../fleet_builder/builder/director.dart';
import '../../fleet_builder/builder/manual_fleet_builder.dart';
import '../../fleet_builder/command/i_command.dart';
import '../../fleet_builder/command/place_ship_command.dart';
import '../../fleet_builder/factory-method/i_ship.dart';

class SetupState implements GameState {
  List<Ship> _shipsToPlace = [];

  final List<ICommand> _commandHistory = [];

  bool _isHorizontal = true;

  set isHorizontal(bool value) {
    _isHorizontal = value;
  }

  @override
  String get stateName => "Розстановка флоту";

  // getter for UI to display current state info
  bool get isHorizontal => _isHorizontal;
  int get remainingShipsCount => _shipsToPlace.length;
  Ship? get currentShip => _shipsToPlace.isNotEmpty ? _shipsToPlace.first : null;

  @override
  void onEnter(GameEngine engine) {
    log("Ініціалізація фази розстановки. Замовляємо кораблі...");

    var manualBuilder = ManualFleetBuilder();
    var director = Director();

    director.constructStandardFleet(manualBuilder);
    _shipsToPlace = manualBuilder.getResult();

    log("До розстановки підготовлено кораблів: ${_shipsToPlace.length}");
  }

  @override
  void handleTap(GameEngine engine, int x, int y) {
    if (_shipsToPlace.isEmpty) {
      log("Всі кораблі вже розставлено!");
      return;
    }

    Ship ship = _shipsToPlace.first;

    ship.isHorizontal = _isHorizontal;

    var command = PlaceShipCommand(engine.playerBoard, ship, x, y);

    bool success = command.execute();

    if (success) {
      _commandHistory.add(command);
      _shipsToPlace.removeAt(0);

      log("Залишилось розставити: ${_shipsToPlace.length}");

      if (_shipsToPlace.isEmpty) {
        log("Флот повністю укомплектовано! Натисніть кнопку 'В бій'.");
      }
    } else {
      log("Не можемо поставити сюди. Місце зайняте або вихід за межі.");
    }
  }

}