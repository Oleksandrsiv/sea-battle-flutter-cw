//import '../core/patterns/factory-method/iship.dart';


import '../core/fleet_builder/factory-method/iship.dart';

enum CellStatus { water, ship, hit, miss, sunk }

class Cell {
  final int x;
  final int y;

  CellStatus status;
  Ship? ship;

  Cell({
    required this.x,
    required this.y,
    this.status = CellStatus.water,
    this.ship,
  });
}