import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class UserModel {
  final String avatarPath;
  final String id;
  final bool isActive;
  final String name;
  final Timestamp purchasedOn;
  final int sequence;
  final String uid;

  UserModel(this.avatarPath, this.id, this.isActive, this.name, this.purchasedOn, this.sequence, this.uid);

  @override
  String toString() => '$name';

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      entity.avatarPath,
      entity.id,
      entity.isActive,
      entity.name,
      Timestamp.fromDate(entity.purchasedOn),
      entity.sequence,
      entity.uid,
    );
  }
}
