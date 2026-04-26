import 'i_builder.dart';

class Director {
  void constructStandardFleet(FleetBuilder builder) {
    builder.reset();
    builder.buildBattleships(1);
    builder.buildCruisers(2);
    builder.buildDestroyers(3);
    builder.buildSubmarines(4);
  }
}