import '../core/patterns/factory-method/product.dart';

enum CellStatus { water, ship, hit, miss }

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