import 'package:flutter_test/flutter_test.dart';
import 'package:sea_battle_cw/core/fleet_builder/factory-method/ship_creator.dart';
import 'package:sea_battle_cw/core/fleet_builder/factory-method/i_ship.dart';



void main() {
  group('Factory Method Tests', () {
    test('Creators should build ships of correct sizes and names', () {
      Ship battleship = BattleshipCreator().createShip();
      expect(battleship.size, 4);
      expect(battleship.name, "Лінкор");

      Ship submarine = SubmarineCreator().createShip();
      expect(submarine.size, 1);
      expect(submarine.name, "Підводний човен");
    });
  });
}