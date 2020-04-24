import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/event_entity.dart';
import '../../domain/entities/event_participant_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../validators/document_snapshot_validator.dart';

extension Extensions on DocumentSnapshot {
  Future<EventEntity> toEvent(String docPath) async {
    // Check if we are working with an event document
    if (!DocumentSnapshotValidator.isDocumentOfType(this, "events", docPath)) {
      return null;
    }

    var date = data['date'] as Timestamp;
    var userRef = data['hostUser'] as DocumentReference;

    var hostUser = await userRef
        .get()
        // Ignore linting to support extension method on DocumentSnapshot.
        // ignore: avoid_types_on_closure_parameters
        .then((DocumentSnapshot snapshot) => snapshot.toUser(userRef.path));

    return EventEntity(
      documentID,
      date != null ? date.toDate() : null,
      hostUser,
      data['status'],
    );
  }

  Future<EventParticipantEntity> toEventParticipant(String docPath) async {
    // Check if we are working with an event document
    var isEventParticipantDoc = DocumentSnapshotValidator.isDocumentOfType(
        this, "event_participants", docPath);

    if (!isEventParticipantDoc) {
      return null;
    }

    var userRef = data['user'] as DocumentReference;
    var hostUser = await userRef
        .get()
        // Ignore linting to support extension method on DocumentSnapshot.
        // ignore: avoid_types_on_closure_parameters
        .then((DocumentSnapshot snapshot) => snapshot.toUser(userRef.path));

    var eventRef = data['event'] as DocumentReference;
    var event = await eventRef
        .get()
        // Ignore linting to support extension method on DocumentSnapshot.
        // ignore: avoid_types_on_closure_parameters
        .then((DocumentSnapshot snapshot) => snapshot.toEvent(eventRef.path));

    if (event == null) {
      return null;
    }

    return EventParticipantEntity(
      documentID,
      event,
      hostUser,
    );
  }

  UserEntity toUser(String docPath) {
    // Check if we are working with a user document
    if (!DocumentSnapshotValidator.isDocumentOfType(this, "users", docPath)) {
      return null;
    }

    var purchasedOn = data['purchasedOn'] as Timestamp;

    return UserEntity(
      documentID,
      data['avatarPath'],
      data['name'],
      purchasedOn != null ? purchasedOn.toDate() : null,
      data['sequence'],
      data['uid'],
      isActive: data['isActive'],
    );
  }
}
