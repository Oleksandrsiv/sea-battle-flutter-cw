import 'i_ship.dart';


class Battleship extends Ship {
  Battleship() : super(4);
  @override
  String get name => "Лінкор";
}

class Cruiser extends Ship {
  Cruiser() : super(3);
  @override
  String get name => "Крейсер";
}

class Destroyer extends Ship {
  Destroyer() : super(2);
  @override
  String get name => "Есмінець";
}

class Submarine extends Ship {
  Submarine() : super(1);
  @override
  String get name => "Підводний човен";
}