import '../entities/event_entity.dart';

extension Extensions on EventEntity {
  Map<String, Object> toDocument() => {
        'date': date,
        'id': id,
        'hostUser': hostUser.referencePath,
        'status': status,
      };
}
