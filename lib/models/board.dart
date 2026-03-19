import '../core/patterns/factory-method/product.dart';
import 'cell.dart';


class Board {
  final int size = 10;
  late List<List<Cell>> grid;

  Board() {
    _initializeBoard();
  }

  void _initializeBoard() {
    grid = List.generate(
      size,
          (y) => List.generate(
        size,
            (x) => Cell(x: x, y: y),
      ),
    );
  }

  bool isValidCoordinates(int x, int y) {
    return x >= 0 && x < size && y >= 0 && y < size;
  }

  bool canPlaceShip(int startX, int startY, int shipSize, bool isHorizontal) {
    // what a orientation?
    int endX = isHorizontal ? startX + shipSize - 1 : startX;
    int endY = isHorizontal ? startY : startY + shipSize - 1;

    if (!isValidCoordinates(startX, startY) || !isValidCoordinates(endX, endY)) {
      return false;
    }

    // space check around ship
    int startCheckX = startX - 1;
    int endCheckX = isHorizontal ? startX + shipSize : startX + 1;

    int startCheckY = startY - 1;
    int endCheckY = isHorizontal ? startY + 1 : startY + shipSize;

    for (int y = startCheckY; y <= endCheckY; y++) {
      for (int x = startCheckX; x <= endCheckX; x++) {
        if (isValidCoordinates(x, y)) {
          if (grid[y][x].status == CellStatus.ship) {
            return false;
          }
        }
      }
    }

    return true;
  }

  void placeShip(Ship ship, int startX, int startY) {
    for (int i = 0; i < ship.size; i++) {
      int x = ship.isHorizontal ? startX + i : startX;
      int y = ship.isHorizontal ? startY : startY + i;

      grid[y][x].ship = ship;
      grid[y][x].status = CellStatus.ship;
    }
  }
}