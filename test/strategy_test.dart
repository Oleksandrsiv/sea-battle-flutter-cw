import 'package:flutter_test/flutter_test.dart';
import 'package:sea_battle_cw/core/patterns/strategy/probe_direction_strategy.dart';
import 'package:sea_battle_cw/core/patterns/strategy/random_hunt_strategy.dart';
import 'package:sea_battle_cw/core/patterns/strategy/destroy_strategy.dart';
import 'package:sea_battle_cw/models/board.dart';
import 'package:sea_battle_cw/models/cell.dart';


void main() {
  group('Bot AI Strategies Tests', () {
    late Board board;

    setUp(() {
      board = Board();
    });

    //hunt
    test('RandomHuntStrategy should pick a valid unknown cell', () {
      final strategy = RandomHuntStrategy();

      var (x, y) = strategy.calculateNextShot(board);

      expect(x, inInclusiveRange(0, 9));
      expect(y, inInclusiveRange(0, 9));

      var status = board.grid[y][x].status;
      expect(status == CellStatus.water || status == CellStatus.ship, isTrue);
    });

    //direction
    test('ProbeDirectionStrategy should check adjacent cells', () {
      final strategy = ProbeDirectionStrategy(5, 5);

      // step 1: must check direction Up (0, -1) -> [5, 4]
      var (x1, y1) = strategy.calculateNextShot(board);
      expect(x1, 5);
      expect(y1, 4);

      // step 2: must check direction Right (1, 0) -> [6, 5]
      var (x2, y2) = strategy.calculateNextShot(board);
      expect(x2, 6);
      expect(y2, 5);

      // step 3: must check direction Down (0, 1) -> [5, 6]
      var (x3, y3) = strategy.calculateNextShot(board);
      expect(x3, 5);
      expect(y3, 6);
    });

    test('ProbeDirectionStrategy should skip out-of-bounds cells', () {
      final strategy = ProbeDirectionStrategy(0, 0);

      // step 1: Up (0, -1) is out of bounds.
      // The algorithm should skip this step and return direction Right (1, 0) -> [1, 0]
      var (x, y) = strategy.calculateNextShot(board);

      expect(x, 1);
      expect(y, 0);
    });


    //destroy
    test('DestroyStrategy should fire along the horizontal line', () {
      board.grid[5][5].status = CellStatus.hit;
      board.grid[5][6].status = CellStatus.hit;

      final strategy = DestroyStrategy(5, 5, 6, 5);

      var (x, y) = strategy.calculateNextShot(board);
      expect(x, 7);
      expect(y, 5);
    });

    test('DestroyStrategy should reverse direction when hitting a miss', () {
      board.grid[5][5].status = CellStatus.hit;
      board.grid[5][6].status = CellStatus.hit;
      board.grid[5][7].status = CellStatus.miss; // right direction is blocked

      final strategy = DestroyStrategy(5, 5, 6, 5);

      var (x, y) = strategy.calculateNextShot(board);
      expect(x, 4); // Має піти вліво від [5, 5]
      expect(y, 5);
    });

    test('DestroyStrategy should handle vertical direction and board limits', () {
      board.grid[1][2].status = CellStatus.hit;
      board.grid[0][2].status = CellStatus.hit; // on the edge of the board, so it should try the opposite direction

      final strategy = DestroyStrategy(2, 1, 2, 0);

      var (x, y) = strategy.calculateNextShot(board);
      expect(x, 2);
      expect(y, 2); // must go down from [2, 1]
    });
  });
}