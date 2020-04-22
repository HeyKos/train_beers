import 'base_entity.dart';
import 'user_entity.dart';

class EventParticipantEntity extends BaseEntity {
  EventParticipantEntity(String id, this.eventId, this.user) : super(id);
  
  /// Members
  String eventId;
  UserEntity user;
}
