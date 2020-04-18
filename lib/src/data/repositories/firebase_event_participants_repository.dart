import 'package:train_beers/src/domain/entities/event_participant_entity.dart';
import 'package:train_beers/src/domain/repositories/event_participants_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/extensions/document_snapshot_extensions.dart';

class FirebaseEventParticipantsRepository implements EventParticipantsRepository {
  final eventCollection = Firestore.instance.collection("events");
  final eventParticpantsCollection = Firestore.instance.collection('event_participants');

  /// Overrides
  @override
  Stream<List<EventParticipantEntity>> getEventParticipants(String eventId) {
    var eventReference = eventCollection.document(eventId);
    return eventParticpantsCollection
      .where("eventId", isEqualTo: eventReference)
      .snapshots()
      .asyncMap(_mapSnaphotToEventParticipants);
  }

  /// Methods
  Future<List<EventParticipantEntity>> _mapSnaphotToEventParticipants(QuerySnapshot snapshot) async {
    List<EventParticipantEntity> _partcipants = [];

    await Future.forEach(snapshot.documents, (DocumentSnapshot doc) async {
      var paricipant = await doc.toEventParticipant(eventParticpantsCollection.path);
      _partcipants.add(paricipant);
    });   
    
    return _partcipants; 
  }
}
