import '../entities/event_participant_entity.dart';

extension Extensions on EventParticipantEntity {
  Map<String, Object> toMap() {
    return {
      'event': event,
      'id': id,
      'user': user,
    };
  }
}
