import 'package:flutter/material.dart';

@immutable
class UserEntity {
  final String id;
  final String name;
  final int sequence;

  UserEntity(this.id, this.name, this.sequence);

  @override
  String toString() => '$name';
}
