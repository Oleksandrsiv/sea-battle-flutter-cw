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

        // TODO: Тут ми маємо додати перевірку на перетин з іншими кораблями.
        // Поки що просто ставимо корабель (спрощена логіка для каркасу).
        if (_board.isValidCoordinates(x, y)) {
          _board.grid[y][x].ship = newShip;
          _board.grid[y][x].status = CellStatus.ship; // SHIP!!!
          placed = true;
        }
      }
    }
  }
}