import 'package:flutter_test/flutter_test.dart';
import 'package:sea_battle_cw/models/board.dart';
import 'package:sea_battle_cw/models/cell.dart';
import 'package:sea_battle_cw/core/patterns/factory-method/product.dart';
import 'package:sea_battle_cw/core/patterns/factory-method/concrete_product.dart'; // Де лежать Battleship, Cruiser тощо

void main() {
  group('Board Logic Tests', () {
    late Board board;

    setUp(() {
      board = Board();
    });

    test('Board should be initialized with 10x10 water cells', () {
      expect(board.grid.length, 10);
      expect(board.grid[0].length, 10);
      expect(board.grid[5][5].status, CellStatus.water);
    });

    test('canPlaceShip should return true for valid horizontal placement', () {
      bool canPlace = board.canPlaceShip(0, 0, 4, true); // Лінкор (4) по горизонталі
      expect(canPlace, isTrue);
    });

    test('canPlaceShip should return false if ship goes out of bounds', () {
      bool canPlace = board.canPlaceShip(8, 0, 4, true); // Лінкор (4) починається з X=8, вилізе за край (8,9,10,11)
      expect(canPlace, isFalse);
    });

    test('placeShip should correctly change cell statuses to ship', () {
      Ship cruiser = Cruiser(); // Розмір 3
      cruiser.isHorizontal = false;

      board.placeShip(cruiser, 2, 2);

      // Перевіряємо, чи клітинки змінили статус
      expect(board.grid[2][2].status, CellStatus.ship);
      expect(board.grid[3][2].status, CellStatus.ship);
      expect(board.grid[4][2].status, CellStatus.ship);

      // Перевіряємо, чи наступна клітинка залишилась водою
      expect(board.grid[5][2].status, CellStatus.water);
    });

    test('receiveShot should return true for a hit and false for a miss', () {
      Ship submarine = Submarine(); // Розмір 1
      board.placeShip(submarine, 5, 5);

      // Стріляємо повз
      bool isHit = board.receiveShot(0, 0);
      expect(isHit, isFalse);
      expect(board.grid[0][0].status, CellStatus.miss);

      // Стріляємо в ціль
      bool isHitTarget = board.receiveShot(5, 5);
      expect(isHitTarget, isTrue);
    });

    test('Ship should sink and create a halo of misses around it', () {
      Ship destroyer = Destroyer(); // Розмір 2
      destroyer.isHorizontal = true;
      board.placeShip(destroyer, 4, 4); // Займає [4,4] і [5,4]

      // Перше влучання - корабель ще живий
      board.receiveShot(4, 4);
      expect(board.grid[4][4].status, CellStatus.hit);
      expect(destroyer.isSunk, isFalse);

      // Друге влучання - корабель тоне
      board.receiveShot(5, 4);
      expect(destroyer.isSunk, isTrue);

      // Перевіряємо, чи змінився статус самого корабля на sunk
      expect(board.grid[4][4].status, CellStatus.sunk);
      expect(board.grid[4][5].status, CellStatus.sunk);

      // Перевіряємо, чи створився ореол промахів (наприклад, зверху над кораблем)
      expect(board.grid[3][4].status, CellStatus.miss);
      expect(board.grid[3][5].status, CellStatus.miss);
    });
  });
}