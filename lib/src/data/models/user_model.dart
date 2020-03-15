import 'package:train_beers/src/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final int sequence;

  UserModel(this.id, this.name, this.sequence);

  @override
  String toString() => '$name';

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      entity.id,
      entity.name,
      entity.sequence,
    );
  }
}
