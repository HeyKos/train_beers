import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/validators/document_snapshot_validator.dart';
import 'package:train_beers/src/domain/entities/event_entity.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

extension Extensions on DocumentSnapshot {
  EventEntity toEvent(String docPath) {
    // Check if we are working with an event document
    if (!DocumentSnapshotValidator.isDocumentOfType(this, "events", docPath)) {
      return null;
    }

    Timestamp date = this.data['date'] as Timestamp;

    return EventEntity (
      this.documentID,
      date != null ? date.toDate() : null,
      this.data['hostUserId'],
      this.data['status'],
    );
  }

  UserEntity toUser(String docPath) {
    // Check if we are working with a user document
    if (!DocumentSnapshotValidator.isDocumentOfType(this, "users", docPath)) {
      return null;
    }

    Timestamp purchasedOn = this.data['purchasedOn'] as Timestamp;

    return UserEntity (
      this.documentID,
      this.data['avatarPath'],
      this.data['isActive'],
      this.data['name'],
      purchasedOn != null ? purchasedOn.toDate() : null,
      this.data['sequence'],
      this.data['uid'],
    );
  }
}