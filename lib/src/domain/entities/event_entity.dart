import '../enums/event_status.dart';
import 'base_entity.dart';
import 'user_entity.dart';

class EventEntity extends BaseEntity {
  EventEntity(String id, this.date, this.hostUser, this.status) : super(id);

  /// Members
  DateTime date;
  UserEntity hostUser;
  EventStatus status;
}
