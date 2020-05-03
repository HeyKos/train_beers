import '../../domain/entities/event_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/enums/event_status.dart';

class EventModel extends EventEntity {
  EventModel(String id, this.date, this.hostUser, this.status)
      : super(id, date, hostUser, status);

  /// Members
  DateTime date;
  UserEntity hostUser;
  EventStatus status;
}
