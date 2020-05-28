import '../entities/user_entity.dart';

extension Extensions on UserEntity {
  Map<String, Object> toDocument() {
    return {
      'avatarPath': avatarPath,
      'id': id,
      'isActive': isActive,
      'name': name,
      'lastHostedOn': lastHostedOn,
      'sequence': sequence,
      'uid': uid,
    };
  }

  Map<String, Object> toMap() {
    return {
      'avatarPath': avatarPath,
      'id': id,
      'isActive': isActive,
      'name': name,
      'lastHostedOn': lastHostedOn.toString(),
      'sequenece': sequence,
      'uid': uid,
    };
  }
}
