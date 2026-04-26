abstract class Ship {
  final int size;
  int _health;
  bool isHorizontal = true;

  Ship(this.size) : _health = size;

  int get health => _health;

  void takeDamage() {
    if (_health > 0) _health--;
  }

  bool get isSunk => _health == 0;

  String get name;
}
