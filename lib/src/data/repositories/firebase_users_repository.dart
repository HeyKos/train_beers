import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/extensions/user_entity_extensions.dart';
import '../../domain/repositories/users_repository.dart';
import '../extensions/document_snapshot_extensions.dart';

class FirebaseUsersRepository implements UsersRepository {
  static Firestore firestore = Firestore.instance;
  final CollectionReference userCollection = firestore.collection('users');

  @override
  Future<void> addNewUser(UserEntity user) {
    return userCollection.add(user.toDocument());
  }

  @override
  Future<void> deleteUser(UserEntity user) async {
    return userCollection.document(user.id).delete();
  }

  @override
  Stream<List<UserEntity>> getActiveUsers() {
    return userCollection
        .where('isActive', isEqualTo: true)
        .orderBy(
          'name',
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) => doc.toUser(userCollection.path))
          .toList();
    });
  }

  @override
  Stream<UserEntity> getLongestSincePurchased() {
    return userCollection
        .where('isActive', isEqualTo: true)
        .orderBy('purchasedOn')
        .limit(1)
        .snapshots()
        .map(
            (snapshot) => snapshot.documents.first.toUser(userCollection.path));
  }

  @override
  Stream<UserEntity> getByUid(String uid) {
    return userCollection.where('uid', isEqualTo: uid).snapshots().map(
        (snapshot) => snapshot.documents.first.toUser(userCollection.path));
  }

  @override
  Future<void> updateUser(UserEntity user) {
    return userCollection.document(user.id).updateData(user.toDocument());
  }

  @override
  Stream<List<UserEntity>> users() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => doc.toUser(userCollection.path))
          .toList();
    });
  }
}
