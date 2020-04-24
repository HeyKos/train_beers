import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/event_entity.dart';
import '../../domain/entities/event_participant_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/event_participants_repository.dart';
import '../extensions/document_snapshot_extensions.dart';

class FirebaseEventParticipantsRepository
    implements EventParticipantsRepository {
  static Firestore firestore = Firestore.instance;
  final CollectionReference eventCollection = firestore.collection('events');
  final CollectionReference eventParticpantsCollection =
      firestore.collection('event_participants');
  final CollectionReference userCollection = firestore.collection('users');

  /// Overrides
  @override
  Future<EventParticipantEntity> create(
      EventParticipantEntity eventParticipant) {
    // Get the document reference to the user and event.
    final userRef = userCollection.document(eventParticipant.user.id);
    final eventRef = eventCollection.document(eventParticipant.event.id);

    return eventParticpantsCollection
        .add({'event': eventRef, 'user': userRef}).then((participantRef) {
      eventParticipant.id = participantRef.documentID;
      return eventParticipant;
    });
  }

  @override
  Future<void> delete(String eventParticipantId) {
    return userCollection.document(eventParticipantId).delete();
  }

  @override
  Stream<List<EventParticipantEntity>> getByEventId(String eventId) {
    final eventReference = eventCollection.document(eventId);
    return eventParticpantsCollection
        .where('event', isEqualTo: eventReference)
        .snapshots()
        .asyncMap(_mapSnaphotToEventParticipants);
  }

  @override
  Future<EventParticipantEntity> getByEventAndUser(
      EventEntity event, UserEntity user) {
    // Get the document reference to the user and event.
    final userRef = userCollection.document(user.id);
    final eventRef = eventCollection.document(event.id);

    return eventParticpantsCollection
        .where('event', isEqualTo: eventRef)
        .where('user', isEqualTo: userRef)
        .snapshots()
        .first
        .then((participantRef) {
      return participantRef.documents.first
          .toEventParticipant(eventParticpantsCollection.path);
    });
  }

  /// Methods
  Future<List<EventParticipantEntity>> _mapSnaphotToEventParticipants(
      QuerySnapshot snapshot) async {
    final _participants = <EventParticipantEntity>[];

    // Need to ignore linting to support extension method on DocumentSnapshot.
    // ignore: avoid_types_on_closure_parameters
    await Future.forEach(snapshot.documents, (DocumentSnapshot doc) async {
      final participant =
          await doc.toEventParticipant(eventParticpantsCollection.path);
      _participants.add(participant);
    });

    return _participants;
  }
}
