import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_masters/models/location_model.dart';
import 'package:fix_masters/models/type_of_work_model.dart';
import 'package:fix_masters/models/user_model.dart';
import 'package:fix_masters/models/worker_form_model.dart';

class DBHelper {
  static const _collectionWorker = 'Workers';
  static const _collectionLocation = 'Location';
  static const _collectionUser = 'Users';
  static const _collectiontypeAndImage = 'Type&Image';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addNewUser(UserModel userModel) {
    return _db
        .collection(_collectionUser)
        .doc(userModel.userId)
        .set(userModel.toMap());
  }

  static Future<void> addNewWorker(WorkerFormModel workerFormModel) {
    final wb = _db.batch();
    final workerDocRef = _db.collection(_collectionWorker).doc();
    workerFormModel.id = workerDocRef.id;
    wb.set(workerDocRef, workerFormModel.toMap());
    return wb.commit();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLocation() =>
      _db.collection(_collectionLocation).snapshots();
  static Future<void> insertRole(String userId, String role) {
    return _db.collection(_collectionUser).doc(userId).update({
      'role': role,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllWorkerByType(
          String type) =>
      _db
          .collection(_collectionWorker)
          .where('type', isEqualTo: type)
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>>
      fetchAllWorkerByTypeAndLocation(String type, String locat) => _db
          .collection(_collectionWorker)
          .where('type', isEqualTo: type)
          .where('location', isEqualTo: locat)
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllTypeAndImage() =>
      _db.collection(_collectiontypeAndImage).snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> workerById(
          String workerId) =>
      _db.collection(_collectionWorker).doc(workerId).snapshots();
  static Future<void> addTypeandImage(TypeofWorkModel typeofWorkModel) {
    final wb = _db.batch();
    final typeDocRef = _db.collection(_collectiontypeAndImage).doc();

    typeofWorkModel.id = typeDocRef.id;

    wb.set(typeDocRef, typeofWorkModel.toMap());

    return wb.commit();
  }

  static Future<void> addLocation(String name, String doc) {
    return _db.collection(_collectionLocation).doc(doc).set({'name': name});
  }

  static Future<void> deleteLocation(String doc) {
    return _db.collection(_collectionLocation).doc(doc).delete();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserDetails(
          String? userId) =>
      _db.collection(_collectionUser).doc(userId).get();
  static Future<void> updateUserProfile(
      String userId, String name, String phone) {
    return _db.collection(_collectionUser).doc(userId).update({
      'name': name,
      'phone': phone,
    });
  }

  static Future<void> updateImage(String userId, String image) {
    return _db
        .collection(_collectionUser)
        .doc(userId)
        .update({'picture': image});
  }
}
