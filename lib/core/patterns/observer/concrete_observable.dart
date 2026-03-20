import '../../../models/cell.dart';
import 'observable.dart';
import 'observer.dart';

class GameEngine implements IGamePublisher {
  final List<IGameSubscriber> _subscribers = [];

  int _lastX = 0;
  int _lastY = 0;
  CellStatus _lastStatus = CellStatus.water;

  int get lastX => _lastX;
  int get lastY => _lastY;
  CellStatus get lastStatus => _lastStatus;

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