import '../../../models/cell.dart';
import '../patterns/observer/observable.dart';
import '../patterns/observer/observer.dart';
import '../patterns/state/concrete_state.dart';
import '../patterns/state/state.dart';

class GameEngine implements IGamePublisher {
// data
  int _lastX = 0;
  int _lastY = 0;
  CellStatus _lastStatus = CellStatus.water;

  int get lastX => _lastX;
  int get lastY => _lastY;
  CellStatus get lastStatus => _lastStatus;

// state. rule, phase of game, turn

  GameState _currentState;

  String get currentStateName => _currentState.stateName;

  GameEngine() : _currentState = SetupState();

  void changeState(GameState newState) {
    _currentState = newState;
    print("Система: Стан змінено на '${newState.stateName}'");
    notifySubscribers();
  }

  void handleCellTap(int x, int y) {
    _currentState.handleTap(this, x, y);
    notifySubscribers();
  }

  bool processShot(int x, int y) {
    _lastX = x;
    _lastY = y;
    // Поки що заглушка: вважаємо, що завжди промах
    _lastStatus = CellStatus.miss;
    return false; // Повертаємо false, щоб PlayerTurnState знав, що ми промазали
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