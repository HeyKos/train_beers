import 'package:flutter/material.dart';

@immutable
class UserEntity {
  final String id;
  String uid;
  String name;
  int sequence;
  bool isActive;
  DateTime purchasedOn;

  UserEntity(this.id, this.uid, this.name, this.sequence, this.isActive, this.purchasedOn);

  set userIsActive(bool value) {
    this.isActive = value;
  }

  @override
  String toString() => '$name';
}
