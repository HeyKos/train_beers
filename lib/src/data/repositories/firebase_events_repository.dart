import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../extensions/document_snapshot_extensions.dart';
import '../extensions/event_entity_extensions.dart';
import '../extensions/event_model_extensions.dart';

class FirebaseEventsRepository implements EventsRepository {
  final CollectionReference eventCollection =
      Firestore.instance.collection('events');
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  /// Overrides
  @override
  Stream<EventEntity> getNextEvent() {
    return eventCollection
        .orderBy('date', descending: true)
        .snapshots()
        .asyncMap(_mapSnaphotToEvent);
  }

  @override
  Future<void> update(EventEntity event) {
    final userRef = userCollection.document(event.hostUser.id);
    var model = event.toModel(userRef);
    return eventCollection.document(event.id).updateData(model.toMap(userRef));
  }

  /// Methods
  Future<EventEntity> _mapSnaphotToEvent(QuerySnapshot snapshot) async {
    return await snapshot.documents.first.toEvent(eventCollection.path);
  }
}
