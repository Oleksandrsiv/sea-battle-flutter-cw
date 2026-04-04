import 'package:flutter_test/flutter_test.dart';
import 'package:sea_battle_cw/core/patterns/builder/concrete_builder.dart';

import 'package:sea_battle_cw/models/board.dart';
import 'package:sea_battle_cw/models/cell.dart';
import 'package:sea_battle_cw/core/patterns/factory-method/concrete_product.dart';
import 'package:sea_battle_cw/core/patterns/builder/director.dart';
import 'package:sea_battle_cw/core/patterns/builder/manual_fleet_builder.dart'; // якщо він у тебе в окремому файлі
import 'package:sea_battle_cw/core/patterns/factory-method/product.dart';


void main() {
    group('Builder Pattern Tests', () {
    test('Director should construct a standard manual fleet of 10 ships', () {
    final builder = ManualFleetBuilder();
    final director = Director();

    director.constructStandardFleet(builder);
    List<Ship> fleet = builder.getResult();

    // За класичними правилами має бути 10 кораблів
    expect(fleet.length, 10);

    // Перевіряємо склад флоту (1 лінкор, 4 підводних човни)
    expect(fleet.whereType<Battleship>().length, 1);
    expect(fleet.whereType<Submarine>().length, 4);
    });

    test('RandomFleetBuilder should place exactly 10 ships on the board', () {
    final builder = RandomFleetBuilder();
    final director = Director();

    director.constructStandardFleet(builder);
    Board generatedBoard = builder.getResult();

    // Рахуємо, скільки клітинок зайнято кораблями
    // 1*4 + 2*3 + 3*2 + 4*1 = 4 + 6 + 6 + 4 = 20 клітинок загалом
    int shipCellsCount = 0;
    for (int y = 0; y < 10; y++) {
    for (int x = 0; x < 10; x++) {
    if (generatedBoard.grid[y][x].status == CellStatus.ship) {
    shipCellsCount++;
    }
    }
    }

    expect(shipCellsCount, 20);
    });
    });
}