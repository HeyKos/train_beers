import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String uid;
  final String name;
  final int sequence;
  final bool isActive;
  final Timestamp purchasedOn;

  UserModel(this.id, this.uid, this.name, this.sequence, this.isActive, this.purchasedOn);

  @override
  String toString() => '$name';

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      entity.id,
      entity.uid,
      entity.name,
      entity.sequence,
      entity.isActive,
      Timestamp.fromDate(entity.purchasedOn),
    );
  }
}
