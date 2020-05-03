import '../entities/event_entity.dart';

abstract class EventsRepository {
  Stream<EventEntity> getNextEvent();
  Future<void> update(EventEntity event);
}
