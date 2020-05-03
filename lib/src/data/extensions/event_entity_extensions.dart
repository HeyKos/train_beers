import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event_entity.dart';

import '../models/event_model.dart';

extension Extensions on EventEntity {
  EventModel toModel(DocumentReference userRef) =>
      EventModel(id, date, hostUser, status);
}
