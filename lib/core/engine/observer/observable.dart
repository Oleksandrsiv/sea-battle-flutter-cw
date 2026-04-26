
import 'observer.dart';

abstract interface class IGamePublisher {
  void subscribe(IGameSubscriber subscriber);
  void unsubscribe(IGameSubscriber subscriber);
  void notifySubscribers();
}