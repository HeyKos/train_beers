import 'package:train_beers/src/domain/entities/base_entity.dart';

class UserEntity extends BaseEntity {
  /// Members
  String avatarPath;
  bool isActive;
  String name;
  int sequence;
  DateTime purchasedOn;
  String uid;
  String avatarUrl;

  UserEntity(String id, this.avatarPath, this.isActive, this.name, this.purchasedOn, this.sequence, this.uid) : super(id);

  /// Properties
  set userIsActive(bool value) {
    this.isActive = value;
  }

  /// Overrides
  @override
  String toString() => '$name';

  /// Methods
  String getActiveStatusMessage() {
    if (this.isActive) {
      return "You're in for beers 🍻";
    }

    return "You're not drinking 😭";
  }
  
  String getWelcomeText() {
    return "Hi there ${this.name}!";
  }
}
