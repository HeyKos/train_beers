import 'package:train_beers/src/domain/entities/base_entity.dart';

class EventParticipantEntity extends BaseEntity {
  /// Members
  String eventId;
  String userId;

  EventParticipantEntity(String id, this.eventId, this.userId) : super(id);
}
