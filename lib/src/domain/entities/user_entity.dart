class UserEntity {
  /// Members
  String avatarPath;
  final String id;
  bool isActive;
  String name;
  int sequence;
  DateTime purchasedOn;
  String uid;
  String avatarUrl;

  UserEntity(this.avatarPath, this.id, this.isActive, this.name, this.purchasedOn, this.sequence, this.uid);

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
