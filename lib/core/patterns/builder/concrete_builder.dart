import 'dart:math';
import '../../../models/board.dart';
import '../../../models/cell.dart';
import '../factory-method/product.dart';
import '../factory-method/creator.dart';
import 'builder.dart';
import '../factory-method/concrete_creator.dart';

class RandomFleetBuilder implements FleetBuilder {
  Board _board = Board();
  final Random _random = Random();

  @override
  void reset() {
    _board = Board();
  }

  @override
  void buildBattleships(int count) {
    _placeRandomly(BattleshipCreator(), count);
  }

  @override
  void buildCruisers(int count) {
    _placeRandomly(CruiserCreator(), count);
  }

  @override
  void buildDestroyers(int count) {
    _placeRandomly(DestroyerCreator(), count);
  }

  @override
  void buildSubmarines(int count) {
    _placeRandomly(SubmarineCreator(), count);
  }

  Board getResult() {
    return _board;
  }

  void _placeRandomly(ShipCreator creator, int count) {
    for (int i = 0; i < count; i++) {
      Ship newShip = creator.createShip();
      bool placed = false;

      while (!placed) {
        // generate rnd cords
        int x = _random.nextInt(10);
        int y = _random.nextInt(10);
        newShip.isHorizontal = _random.nextBool(); // Випадкова орієнтація

        // check if ship can be placed at these cords
        if (_board.canPlaceShip(x, y, newShip.size, newShip.isHorizontal)) {

          // if true -> place ship on the board
          for (int j = 0; j < newShip.size; j++) {
            int currentX = newShip.isHorizontal ? x + j : x;
            int currentY = newShip.isHorizontal ? y : y + j;

            _board.grid[currentY][currentX].ship = newShip;
            _board.grid[currentY][currentX].status = CellStatus.ship;
          }
          placed = true;
        }
      }
    }
  }
}