import 'package:flutter_test/flutter_test.dart';
import 'package:sea_battle_cw/core/patterns/factory-method/product.dart';
import 'package:sea_battle_cw/models/board.dart';
import 'package:sea_battle_cw/models/cell.dart';
import 'package:sea_battle_cw/core/patterns/factory-method/concrete_product.dart';
import 'package:sea_battle_cw/core/patterns/command/concrete_command.dart';


void main() {
  group('Command Pattern Tests', () {
    late Board board;

    setUp(() {
      board = Board();
    });

    test('PlaceShipCommand should execute correctly and place a ship', () {
      Ship cruiser = Cruiser(); // Розмір 3
      cruiser.isHorizontal = true;

      final command = PlaceShipCommand(board, cruiser, 2, 2);
      bool result = command.execute();

      expect(result, isTrue);
      expect(board.grid[2][2].status, CellStatus.ship);
      expect(board.grid[2][4].status, CellStatus.ship);
    });

    test('PlaceShipCommand should NOT execute if placement is invalid', () {
      Ship cruiser1 = Cruiser();
      cruiser1.isHorizontal = true;
      board.placeShip(cruiser1, 2, 2); // Займаємо координати [2,2], [3,2], [4,2]

      Ship cruiser2 = Cruiser(); // try to place another cruiser on top of it
      cruiser2.isHorizontal = false;

      final command = PlaceShipCommand(board, cruiser2, 2, 2);
      bool result = command.execute();

      expect(result, isFalse); // must fail because [2,2] is already occupied
      // check that the original ship is still there and unchanged
      expect(board.grid[2][2].ship, cruiser1);
    });

    test('PlaceShipCommand undo() should remove the ship from the board', () {
      Ship destroyer = Destroyer();
      destroyer.isHorizontal = true;

      final command = PlaceShipCommand(board, destroyer, 5, 5);

      command.execute();
      expect(board.grid[5][5].status, CellStatus.ship);

      command.undo();

      // Перевіряємо, чи повернулася вода
      expect(board.grid[5][5].status, CellStatus.water);
      expect(board.grid[5][6].status, CellStatus.water);
      expect(board.grid[5][5].ship, isNull);
    });
  });
}