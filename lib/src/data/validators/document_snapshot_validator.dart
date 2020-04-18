import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentSnapshotValidator {
  static bool isDocumentOfType(DocumentSnapshot document, String documentType, String documentPath) {
    if (documentPath.toLowerCase() != documentType.toLowerCase()) return false;

    if (document.data == null) return false;
    
    return true;
  }
}
