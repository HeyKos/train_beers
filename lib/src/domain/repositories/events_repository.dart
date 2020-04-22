import '../entities/event_entity.dart';

abstract class EventsRepository {
  Stream<EventEntity> getNextEvent();
}
