import '../factory-method/ship_creator.dart';
import '../factory-method/i_ship.dart';
import 'i_builder.dart';

class ManualFleetBuilder implements FleetBuilder {
  final List<Ship> _ships = [];

  @override
  void reset() {
    _ships.clear();
  }

  @override
  void buildBattleships(int count) {
    for (int i = 0; i < count; i++) _ships.add(BattleshipCreator().createShip());
  }

  @override
  void buildCruisers(int count) {
    for (int i = 0; i < count; i++) _ships.add(CruiserCreator().createShip());
  }

  @override
  void buildDestroyers(int count) {
    for (int i = 0; i < count; i++) _ships.add(DestroyerCreator().createShip());
  }

  @override
  void buildSubmarines(int count) {
    for (int i = 0; i < count; i++) _ships.add(SubmarineCreator().createShip());
  }

  List<Ship> getResult() => _ships;
}