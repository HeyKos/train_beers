import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/models/user_model.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class UsersMapper {
  
  static Map<String, Object> userModelToJson(UserModel model) {
    return {
      'avatarPath': model.avatarPath,
      'id': model.id,
      'isActive': model.isActive,
      'name': model.name,
      'purchasedOn': model.purchasedOn.toString(),
      'sequenece': model.sequence,
      'uid': model.uid,
    };
  }

  static UserModel userModelFromJson(Map<String, Object> json) {
    return UserModel(
      json['avatarPath'] as String,
      json['id'] as String,
      json['isActive'] as bool,
      json['name'] as String,
      json['purchasedOn'] as Timestamp,
      json['sequence'] as int,
      json['uid'] as String,
    );
  }

  static UserModel userModelFromSnapshot(DocumentSnapshot snap) {
    var user = UserModel(
      snap.data['avatarPath'],
      snap.documentID,
      snap.data['isActive'],
      snap.data['name'],
      snap.data['purchasedOn'],
      snap.data['sequence'],
      snap.data['uid'],
    );

    return user;
  }

  static Map<String, Object> userModelToDocument(UserModel model) {
    return {
      'avatarPath': model.avatarPath,
      'id': model.id,
      'isActive': model.isActive,
      'name': model.name,
      'purchasedOn': model.purchasedOn,
      'sequence': model.sequence,
      'uid': model.uid,
    };
  }

  static UserEntity userEntityFromUserModel(UserModel userModel) {
    return UserEntity (
      userModel.avatarPath,
      userModel.id,
      userModel.isActive,
      userModel.name,
      userModel.purchasedOn.toDate(),
      userModel.sequence,
      userModel.uid,
    );
  }

  static UserEntity userEntityFromSnapshot(DocumentSnapshot snap) {
    return userEntityFromUserModel(userModelFromSnapshot(snap));
  }
}
