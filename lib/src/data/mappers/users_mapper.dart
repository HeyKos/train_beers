import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/models/user_model.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class UsersMapper {
  
  static Map<String, Object> userModelToJson(UserModel model) {
    return {
      'id': model.id,
      'uid': model.uid,
      'name': model.name,
      'sequenece': model.sequence,
      'isActive': model.isActive,
      'purchasedOn': model.purchasedOn.toString(),
    };
  }

  static UserModel userModelFromJson(Map<String, Object> json) {
    return UserModel(
      json['id'] as String,
      json['uid'] as String,
      json['name'] as String,
      json['sequence'] as int,
      json['isActive'] as bool,
      json['purchasedOn'] as Timestamp,
    );
  }

  static UserModel userModelFromSnapshot(DocumentSnapshot snap) {
    var user = UserModel(
      snap.documentID,
      snap.data['uid'],
      snap.data['name'],
      snap.data['sequence'],
      snap.data['isActive'],
      snap.data['purchasedOn'],
    );

    return user;
  }

  static Map<String, Object> userModelToDocument(UserModel model) {
    return {
      'name': model.name,
      'sequence': model.sequence,
      'isActive': model.isActive,
      'purchasedOn': model.purchasedOn,
    };
  }

  static UserEntity userEntityFromUserModel(UserModel userModel) {
    return UserEntity (
      userModel.id,
      userModel.uid,
      userModel.name,
      userModel.sequence,
      userModel.isActive,
      userModel.purchasedOn.toDate()
    );
  }

  static UserEntity userEntityFromSnapshot(DocumentSnapshot snap) {
    return userEntityFromUserModel(userModelFromSnapshot(snap));
  }
}
