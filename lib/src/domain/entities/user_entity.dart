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
  String get initials {
    var nameParts =  name.toUpperCase().split(" ");
    if (nameParts.length >= 2) {
      return "${nameParts[0]} ${nameParts[1]}";
    }
    
    return name.toUpperCase().substring(0, 1);
  }

  String get statusMessage {
    if (this.isActive) {
      return "You're in for beers 🍻";
    }

    return "You're not drinking 😭";
  }

  set userIsActive(bool value) {
    this.isActive = value;
  }
  
  String get welcomeText => "Hi there ${this.name}!";

  /// Overrides
  @override
  String toString() => '$name';
}
