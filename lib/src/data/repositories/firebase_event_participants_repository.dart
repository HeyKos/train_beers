import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/event_participant_entity.dart';
import '../../domain/repositories/event_participants_repository.dart';
import '../extensions/document_snapshot_extensions.dart';

class FirebaseEventParticipantsRepository
    implements EventParticipantsRepository {
  static Firestore firestore = Firestore.instance;
  final CollectionReference eventCollection = firestore.collection('events');
  final CollectionReference eventParticpantsCollection =
      firestore.collection('event_participants');

  /// Overrides
  @override
  Stream<List<EventParticipantEntity>> getEventParticipants(String eventId) {
    final eventReference = eventCollection.document(eventId);
    return eventParticpantsCollection
        .where('event', isEqualTo: eventReference)
        .snapshots()
        .asyncMap(_mapSnaphotToEventParticipants);
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
