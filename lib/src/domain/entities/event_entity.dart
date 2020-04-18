import 'package:train_beers/src/domain/entities/base_entity.dart';

class EventEntity extends BaseEntity {
  /// Members
  DateTime date;
  String hostUserId;
  String status;

  EventEntity(String id, this.date, this.hostUserId, this.status) : super(id);
}
