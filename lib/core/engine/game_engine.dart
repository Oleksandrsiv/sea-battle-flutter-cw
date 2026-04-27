import 'dart:developer';
import 'package:sea_battle_cw/core/engine/state/setup_state.dart';
import 'package:sea_battle_cw/core/engine/state/state.dart';
import '../../../models/cell.dart';
import '../../models/board.dart';
import '../ai/strategy/destroy_strategy.dart';
import '../ai/strategy/probe_direction_strategy.dart';
import '../ai/strategy/random_hunt_strategy.dart';
import '../ai/strategy/i_bot_strategy.dart';
import 'observer/observable.dart';
import 'observer/observer.dart';

  class GameEngine implements IGamePublisher {
  // data
    int _lastX = 0;
    int _lastY = 0;
    CellStatus _lastStatus = CellStatus.water;

    int get lastX => _lastX;
    int get lastY => _lastY;
    CellStatus get lastStatus => _lastStatus;

    Board playerBoard = Board();
    Board botBoard = Board();

    IBotStrategy botStrategy = RandomHuntStrategy();


  // some helper methods for state and strategy to interact with the engine
    void recordLastShot(int x, int y, CellStatus status) {
      _lastX = x;
      _lastY = y;
      _lastStatus = status;
    }

    void updateBotStrategy(bool isHit, int hitX, int hitY) {
      if (_lastStatus == CellStatus.sunk) {
        log("Bot sunk a ship. Returning to RandomHuntStrategy.");
        botStrategy = RandomHuntStrategy();
        return;
      }

      if (isHit) {
        if (botStrategy is RandomHuntStrategy) {
          log("First hit by bot at [$hitX, $hitY]. Switching to ProbeDirectionStrategy to find the rest of the ship.");
          botStrategy = ProbeDirectionStrategy(hitX, hitY);

        } else if (botStrategy is ProbeDirectionStrategy) {
          log("Second hit by bot. Vector found. Transitioning to DestroyStrategy.");

          var probeStrategy = botStrategy as ProbeDirectionStrategy;

          botStrategy = DestroyStrategy(
            probeStrategy.firstHitX,
            probeStrategy.firstHitY,
            hitX,
            hitY,
          );
        }
        // if botStrategy is DestroyStrategy,
        // we just continue with the same strategy until the ship is sunk,
        // then we will switch back to RandomHuntStrategy in the next turn.
      }
    }


  // state. rule, phase of game, turn

    GameState _currentState;
    GameState get currentState => _currentState;
    String get currentStateName => _currentState.stateName;

    GameEngine() : _currentState = SetupState(){
      _currentState.onEnter(this);
    }

    void changeState(GameState newState) {
      _currentState = newState;
      _currentState.onEnter(this);
      print("System: State changed to '${newState.stateName}'");
      notifySubscribers();
    }

    void handleCellTap(int x, int y) {
      _currentState.handleTap(this, x, y);
      notifySubscribers();
    }


  // observer
    final List<IGameSubscriber> _subscribers = [];

    @override
    void subscribe(IGameSubscriber subscriber) {
      _subscribers.add(subscriber);
    }

    @override
    void unsubscribe(IGameSubscriber subscriber) {
      _subscribers.remove(subscriber);
    }

    @override
    void notifySubscribers() {
      for (var subscriber in _subscribers) {
        subscriber.update();
      }
    }
  }