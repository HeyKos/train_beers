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
  Stream<List<UserEntity>> users() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => 
            UsersMapper.userEntityFromUserModel(
                UsersMapper.userModelFromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateUser(UserEntity update) {
    return userCollection
        .document(update.id)
        .updateData(UsersMapper.userModelToDocument(UserModel.fromEntity(update)));
  }
}
