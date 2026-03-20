import '../../engine/game_engine.dart';

abstract class GameState {
  String get stateName;

  void handleTap(GameEngine engine, int x, int y);
}