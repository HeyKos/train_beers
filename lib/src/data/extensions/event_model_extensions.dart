import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

extension Extensions on EventModel {
  Map<String, Object> toMap(DocumentReference userRef) {
    return {
      'date': date,
      'id': id,
      'hostUser': userRef,
      'status': status.index,
    };
  }
}
