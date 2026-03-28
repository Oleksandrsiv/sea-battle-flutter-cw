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

    void removeShip(int startX, int startY) {
    Cell cell = grid[startY][startX];
    if (cell.status == CellStatus.ship && cell.ship != null) {
      Ship ship = cell.ship!;
      for (int i = 0; i < ship.size; i++) {
        int x = ship.isHorizontal ? startX + i : startX;
        int y = ship.isHorizontal ? startY : startY + i;
        grid[y][x].ship = null;
        grid[y][x].status = CellStatus.water;
      }
    }
  }

  // returns true if there is at least one alive ship with size > 1
  bool hasMultiDeckShipsAlive() {
    Set<Ship> aliveShips = {}; // Use a set to avoid duplicates

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        Ship? ship = grid[y][x].ship;
        if (ship != null && !ship.isSunk) {
          aliveShips.add(ship);
        }
      }
    }

    // check if there is at least one alive ship with size > 1
    return aliveShips.any((ship) => ship.size > 1);
  }


  //NEW LOGIC FOR SHOT
  // returns true if hit
  bool receiveShot(int targetX, int targetY) {
    if (!isValidCoordinates(targetX, targetY)) return false;

    Cell targetCell = grid[targetY][targetX];

    // Target hit!
    if (targetCell.status == CellStatus.ship && targetCell.ship != null) {
      targetCell.status = CellStatus.hit; // Ранимо клітинку

      Ship hitShip = targetCell.ship!;
      hitShip.takeDamage();

      if (hitShip.isSunk) {
        _markShipAsSunk(hitShip);
      }
      return true; // hit signal
    }
    // miss
    else if (targetCell.status == CellStatus.water) {
      targetCell.status = CellStatus.miss;
      return false; // Сигнал про промах
    }

    // (hit, miss, sunk)
    return false;
  }

  // mark ship as sunk and mark surrounding cells as miss
  void _markShipAsSunk(Ship ship) {
    int minX = size, maxX = -1;
    int minY = size, maxY = -1;

    // change status of ship cells to sunk and find boundaries of the ship
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (grid[y][x].ship == ship) {
          grid[y][x].status = CellStatus.sunk;

          // Записуємо крайні точки корабля
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }

    // mark surrounding cells as miss
    for (int y = minY - 1; y <= maxY + 1; y++) {
      for (int x = minX - 1; x <= maxX + 1; x++) {
        if (isValidCoordinates(x, y)) {
         // if the cell is water, mark it as miss (to indicate that there can't be any ship there)
          if (grid[y][x].status == CellStatus.water) {
            grid[y][x].status = CellStatus.miss;
          }
        }
      }
    }
  }
}