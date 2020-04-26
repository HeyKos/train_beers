import 'base_entity.dart';

class UserEntity extends BaseEntity {
  UserEntity(String id, this.avatarPath, this.name, this.purchasedOn,
      this.sequence, this.uid)
      : super(id);

  /// Members
  String avatarPath;
  String name;
  int sequence;
  DateTime purchasedOn;
  String uid;
  String avatarUrl;

  /// Properties
  String get initials {
    final nameParts = name.toUpperCase().split(' ');
    if (nameParts.length >= 2) {
      var firstInitial = nameParts[0].substring(0, 1);
      var lastInitial = nameParts[1].substring(0, 1);
      return '$firstInitial $lastInitial';
    }

    return name.toUpperCase().substring(0, 1);
  }

  /// Overrides
  @override
  String toString() => '$name';
}
