import 'base_entity.dart';
import 'event_entity.dart';
import 'user_entity.dart';

class EventParticipantEntity extends BaseEntity {
  EventParticipantEntity(String id, this.event, this.user) : super(id);
  
  /// Members
  EventEntity event;
  UserEntity user;
}
