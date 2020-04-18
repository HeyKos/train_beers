import 'package:train_beers/src/domain/entities/event_entity.dart';

abstract class EventsRepository {
    Stream<EventEntity> getNextEvent();
}
