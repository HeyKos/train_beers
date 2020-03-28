class UserEntity {
  /// Members
  final String id;
  String uid;
  String name;
  int sequence;
  bool isActive;
  DateTime purchasedOn;

  UserEntity(this.id, this.uid, this.name, this.sequence, this.isActive, this.purchasedOn);

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
      return "You're currently in for beers!";
    }

    return "You're not drinking beers this week.";
  }
  
  String getWelcomeText() {
    return "Hi there ${this.name}!";
  }
}
