import 'i_ship.dart';


class Battleship extends Ship {
  Battleship() : super(4);
  @override
  String get name => "Battleship";
}

class Cruiser extends Ship {
  Cruiser() : super(3);
  @override
  String get name => "Cruiser";
}

class Destroyer extends Ship {
  Destroyer() : super(2);
  @override
  String get name => "Destroyer";
}

class Submarine extends Ship {
  Submarine() : super(1);
  @override
  String get name => "Submarine";
}