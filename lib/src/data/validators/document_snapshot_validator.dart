import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentSnapshotValidator {
  static bool isDocumentOfType(DocumentSnapshot document, String documentType, String documentPath) {
    documentPath = documentPath.toLowerCase();
    documentType = documentType.toLowerCase();
    if (!documentPath.contains(documentType)) return false;

    if (document.data == null) return false;
    
    return true;
  }
}
