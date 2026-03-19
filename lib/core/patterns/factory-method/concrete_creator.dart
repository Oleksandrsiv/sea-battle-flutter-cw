import 'creator.dart';
import 'product.dart';
import 'concrete_product.dart';

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