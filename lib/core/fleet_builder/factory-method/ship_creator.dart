import 'i_ship_creator.dart';
import 'i_ship.dart';
import 'ship.dart';

class BattleshipCreator extends ShipCreator {
  @override
  Ship createShip() => Battleship();
}

class CruiserCreator extends ShipCreator {
  @override
  Ship createShip() => Cruiser();
}

class DestroyerCreator extends ShipCreator {
  @override
  Ship createShip() => Destroyer();
}

class SubmarineCreator extends ShipCreator {
  @override
  Ship createShip() => Submarine();
}