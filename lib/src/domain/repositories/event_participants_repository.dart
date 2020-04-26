import '../entities/event_entity.dart';
import '../entities/event_participant_entity.dart';
import '../entities/user_entity.dart';

abstract class EventParticipantsRepository {
  Future<EventParticipantEntity> create(
      EventParticipantEntity eventParticipant);
  Future<void> delete(String eventParticipantId);
  Stream<List<EventParticipantEntity>> getByEventId(String eventId);
  Future<EventParticipantEntity> getByEventAndUser(
      EventEntity event, UserEntity user);
  Future<EventParticipantEntity> updateParticipationStatus(
      EventEntity event, UserEntity user,
      {bool isParticipating = false});
}
