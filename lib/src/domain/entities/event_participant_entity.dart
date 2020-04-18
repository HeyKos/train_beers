import 'package:train_beers/src/domain/entities/base_entity.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class EventParticipantEntity extends BaseEntity {
  /// Members
  String eventId;
  UserEntity user;

  EventParticipantEntity(String id, this.eventId, this.user) : super(id);
}
