import 'package:fix_masters/db/db_helper.dart';
import 'package:fix_masters/models/location_model.dart';
import 'package:fix_masters/models/type_of_work_model.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class AdminProvider extends ChangeNotifier {
  Future<void> addTypeandImage(TypeofWorkModel typeofWorkModel) {
    return DBHelper.addTypeandImage(typeofWorkModel);
  }

  Future<void> addLocation(String name, String doc) =>
      DBHelper.addLocation(name, doc);
  Future<void> deleteLocation(String doc) => DBHelper.deleteLocation(doc);
}
