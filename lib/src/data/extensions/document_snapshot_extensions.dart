import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/validators/document_snapshot_validator.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

extension Extensions on DocumentSnapshot {
  UserEntity toUser(String docPath) {
    // Check if we are working with a user document
    if (!DocumentSnapshotValidator.isUserDocument(this, docPath)) {
      return null;
    }

    Timestamp purchasedOn = this.data['purchasedOn'] as Timestamp;

    return UserEntity (
      this.data['avatarPath'],
      this.documentID,
      this.data['isActive'],
      this.data['name'],
      purchasedOn != null ? purchasedOn.toDate() : null,
      this.data['sequence'],
      this.data['uid'],
    );
  }
}