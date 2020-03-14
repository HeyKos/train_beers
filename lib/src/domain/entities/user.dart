class User {
  final String uid;
  final String name;
  final int sequence;
  User(this.uid, this.name, this.sequence);

  @override
  String toString() => '$name';
}
