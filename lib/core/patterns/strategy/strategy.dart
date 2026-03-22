

import '../../../models/board.dart';

abstract interface class IBotStrategy {
  (int x, int y) calculateNextShot(Board targetBoard);
}