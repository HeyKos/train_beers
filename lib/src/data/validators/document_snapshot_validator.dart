import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentSnapshotValidator {
  static bool isUserDocument(DocumentSnapshot document, String documentPath) {
    if (documentPath != "users") return false;

    if (document.data == null) return false;
    
    return true;
  }
}