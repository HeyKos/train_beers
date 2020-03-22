import 'package:flutter/material.dart';

@immutable
class UserEntity {
  final String id;
  final String uid;
  final String name;
  final int sequence;
  final bool isActive;
  final DateTime purchasedOn;

  UserEntity(this.id, this.uid, this.name, this.sequence, this.isActive, this.purchasedOn);

  @override
  String toString() => '$name';
}
