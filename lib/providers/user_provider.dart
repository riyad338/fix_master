import 'package:fix_masters/db/db_helper.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  Future<void> addUser(UserModel userModel) {
    return DBHelper.addNewUser(userModel);
  }

  Future<UserModel?> getCurrentUser(String userId) async {
    final snapshot = await DBHelper.fetchUserDetails(userId);
    if (!snapshot.exists) {
      return null;
    }
    return UserModel.fromMap(snapshot.data()!);
  }

  Future<void> updateUserProfile(
    String userId,
    String name,
    String phone,
  ) =>
      DBHelper.updateUserProfile(userId, name, phone);

  Future<void> updateImage(String userId, String image) =>
      DBHelper.updateImage(userId, image);
}
