import 'package:train_beers/src/domain/entities/base_entity.dart';

class EventEntity extends BaseEntity {
  /// Members
  DateTime date;
  String userId;

  EventEntity(String id, this.date, this.userId) : super(id);
}
