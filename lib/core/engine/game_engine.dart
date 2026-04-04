  import 'dart:developer';

import '../../../models/cell.dart';
  import '../../models/board.dart';
import '../patterns/observer/observable.dart';
  import '../patterns/observer/observer.dart';
  import '../patterns/state/concrete_setup_state.dart';
  import '../patterns/state/state.dart';
import '../patterns/strategy/destroy_strategy.dart';
import '../patterns/strategy/probe_direction_strategy.dart';
import '../patterns/strategy/random_hunt_strategy.dart';
import '../patterns/strategy/strategy.dart';

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
        log("Бот потопив корабель! Повернення до режиму пошуку.");
        botStrategy = RandomHuntStrategy();
        return;
      }

      if (isHit) {
        if (botStrategy is RandomHuntStrategy) {
          log("Перше влучання бота. Перехід на ProbeDirectionStrategy.");
          botStrategy = ProbeDirectionStrategy(hitX, hitY);

        } else if (botStrategy is ProbeDirectionStrategy) {
          log("Друге влучання бота. Вектор знайдено. Перехід на DestroyStrategy.");

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

    String get currentStateName => _currentState.stateName;

    GameEngine() : _currentState = SetupState(){
      _currentState.onEnter(this);
    }

    void changeState(GameState newState) {
      _currentState = newState;
      _currentState.onEnter(this);
      print("Система: Стан змінено на '${newState.stateName}'");
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