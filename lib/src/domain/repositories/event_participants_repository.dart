import 'package:train_beers/src/domain/entities/event_participant_entity.dart';

abstract class EventParticipantsRepository {
    Stream<List<EventParticipantEntity>> getEventParticipants(String eventId);
}
