import 'package:train_beers/src/data/mappers/users_mapper.dart';
import 'package:train_beers/src/data/models/user_model.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:train_beers/src/domain/repositories/users_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUsersRepository implements UsersRepository {
  final userCollection = Firestore.instance.collection('users');

  @override
  Future<void> addNewUser(UserEntity user) {
    return userCollection.add(UsersMapper.userModelToDocument(UserModel.fromEntity(user)));
  }

  @override
  Future<void> deleteUser(UserEntity user) async {
    return userCollection.document(user.id).delete();
  }

  @override
  Stream<List<UserEntity>> getActiveUsers() {
    return userCollection
      .where('isActive', isEqualTo: true)
      .orderBy("name",)
      .snapshots()
      .map((snapshot) {
        return snapshot.documents
          .map((doc) {
            return UsersMapper.userEntityFromUserModel(
                UsersMapper.userModelFromSnapshot(doc));
          }).toList();
      });
  }

  @override
  Stream<UserEntity> getLongestSincePurchased() {
    return userCollection
      .where('isActive', isEqualTo: true)
      .orderBy("purchasedOn")
      .limit(1)
      .snapshots()
      .map((snapshot) {
        return UsersMapper.userEntityFromSnapshot(snapshot.documents[0]);
      });
  }

  @override
  Stream<UserEntity> getUserByUid(String uid) {
    return userCollection
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((snapshot) {
        var result = snapshot.documents.first;
        return UsersMapper.userEntityFromUserModel(
          UsersMapper.userModelFromSnapshot(result)
        );
      });
  }

  @override
  Future<void> updateUser(UserEntity update) {
    return userCollection
        .document(update.id)
        .updateData(UsersMapper.userModelToDocument(UserModel.fromEntity(update)));
  }

  @override
  Stream<List<UserEntity>> users() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => 
            UsersMapper.userEntityFromUserModel(
                UsersMapper.userModelFromSnapshot(doc)))
          .toList();
    });
  }
}
