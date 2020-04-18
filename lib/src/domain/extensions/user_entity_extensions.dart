import 'package:train_beers/src/domain/entities/user_entity.dart';

extension Extensions on UserEntity {
  Map<String, Object> toDocument() {
    return {
      'avatarPath': this.avatarPath,
      'id': this.id,
      'isActive': this.isActive,
      'name': this.name,
      'purchasedOn': this.purchasedOn,
      'sequence': this.sequence,
      'uid': this.uid,
    };
  }
  
  Map<String, Object> toMap() {
    return {
      'avatarPath': this.avatarPath,
      'id': this.id,
      'isActive': this.isActive,
      'name': this.name,
      'purchasedOn': this.purchasedOn.toString(),
      'sequenece': this.sequence,
      'uid': this.uid,
    };
  }
}