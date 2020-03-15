import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:train_beers/src/data/models/user_model.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class UsersMapper {
  
  Map<String, Object> userModelToJson(UserModel model) {
    return {
      'id': model.id,
      'name': model.name,
      'sequenece': model.sequence,
    };
  }

  static UserModel userModelFromJson(Map<String, Object> json) {
    return UserModel(
      json['id'] as String,
      json['name'] as String,
      json['sequence'] as int,
    );
  }

  static UserModel userModelFromSnapshot(DocumentSnapshot snap) {
    var user = UserModel(
      snap.documentID,
      snap.data['name'],
      snap.data['sequence'],
    );

    return user;
  }

  static Map<String, Object> userModelToDocument(UserModel model) {
    return {
      'name': model.name,
      'sequence': model.sequence,
    };
  }

  static UserEntity userEntityFromUserModel(UserModel userModel) {
    return UserEntity (userModel.id, userModel.name, userModel.sequence);
  }
}
