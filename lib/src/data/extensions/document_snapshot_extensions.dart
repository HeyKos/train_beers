import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/validators/document_snapshot_validator.dart';
import 'package:train_beers/src/domain/entities/event_entity.dart';
import 'package:train_beers/src/domain/entities/event_participant_entity.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

extension Extensions on DocumentSnapshot {
  Future<EventEntity> toEvent(String docPath) async {
    // Check if we are working with an event document
    if (!DocumentSnapshotValidator.isDocumentOfType(this, "events", docPath)) {
      return null;
    }

    Timestamp date = this.data['date'] as Timestamp;
    DocumentReference userRef = this.data['hostUser'] as DocumentReference;
    UserEntity hostUser = await userRef.get()
      .then((DocumentSnapshot snapshot) => snapshot.toUser(userRef.path));

    return EventEntity (
      this.documentID,
      date != null ? date.toDate() : null,
      hostUser,
      this.data['status'],
    );
  }

  Future<EventParticipantEntity> toEventParticipant(String docPath) async {
    // Check if we are working with an event document
    if (!DocumentSnapshotValidator.isDocumentOfType(this, "event_participants", docPath)) {
      return null;
    }

    DocumentReference userRef = this.data['user'] as DocumentReference;
    UserEntity hostUser = await userRef.get()
      .then((DocumentSnapshot snapshot) => snapshot.toUser(userRef.path));
    
    DocumentReference eventRef = this.data['event'] as DocumentReference;
    EventEntity event = await eventRef.get()
      .then((DocumentSnapshot snapshot) => snapshot.toEvent(eventRef.path));

    return EventParticipantEntity (
      this.documentID,
      event.id,
      hostUser,
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