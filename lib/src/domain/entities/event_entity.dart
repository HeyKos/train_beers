import 'package:train_beers/src/domain/entities/base_entity.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class EventEntity extends BaseEntity {
  /// Members
  DateTime date;
  UserEntity hostUser;
  String status;

  EventEntity(String id, this.date, this.hostUser, this.status) : super(id);
}
