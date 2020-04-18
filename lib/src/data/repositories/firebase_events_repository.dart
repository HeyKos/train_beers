import 'package:train_beers/src/domain/entities/event_entity.dart';
import 'package:train_beers/src/domain/repositories/events_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/extensions/document_snapshot_extensions.dart';

class FirebaseEventsRepository implements EventsRepository {
  final eventCollection = Firestore.instance.collection('events');

  @override
  Stream<EventEntity> getNextEvent() {
    return eventCollection
      .orderBy("date", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.documents.first.toEvent(eventCollection.path));
  }
}
