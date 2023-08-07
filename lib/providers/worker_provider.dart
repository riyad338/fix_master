import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fix_masters/db/db_helper.dart';
import 'package:fix_masters/models/type_of_work_model.dart';
import 'package:fix_masters/models/user_model.dart';
import 'package:fix_masters/models/worker_form_model.dart';
import 'package:flutter/foundation.dart';

class WorkerProvider extends ChangeNotifier {
  List<String> locationList = [];
  List<String> carouselSliderimg = [];
  List<String> workTypeList = [];
  List<WorkerFormModel> workerList = [];
  List<WorkerFormModel> workerLocationList = [];
  List<TypeofWorkModel> typeAndImageList = [];
  List<TypeofWorkModel> popularList = [];
  List<WorkerFormModel> workerByIdList = [];
  Future<void> insertNewWorker(WorkerFormModel workerFormModel) {
    return DBHelper.addNewWorker(workerFormModel);
  }

  init() {
    _getAllLocation();
    _getAllWorkType();
    _fetchAllTypeAndImage();
    _getCarouselSliderImage();
    _fetchAllPopular();
  }

  void _getAllLocation() {
    DBHelper.getLocation().listen((snapshot) {
      locationList = List.generate(
          snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      notifyListeners();
    });
  }

  void _getAllWorkType() {
    DBHelper.fetchAllTypeAndImage().listen((snapshot) {
      workTypeList = List.generate(
          snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      notifyListeners();
    });
  }

  void _getCarouselSliderImage() {
    DBHelper.fetchAllTypeAndImage().listen((snapshot) {
      carouselSliderimg = List.generate(snapshot.docs.length,
          (index) => snapshot.docs[index].data()['imageDownloadUrl']);
      notifyListeners();
    });
  }

  Future<void> insertRole(String userId, String role) =>
      DBHelper.insertRole(userId, role);

  void fetchAllWorkerByType(String type) {
    DBHelper.fetchAllWorkerByType(type).listen((event) {
      workerList = List.generate(event.docs.length,
          (index) => WorkerFormModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void fetchAllWorkerByTypeAndLocation(String type, String locat) {
    DBHelper.fetchAllWorkerByTypeAndLocation(type, locat).listen((event) {
      workerLocationList = List.generate(event.docs.length,
          (index) => WorkerFormModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void _fetchAllTypeAndImage() {
    DBHelper.fetchAllTypeAndImage().listen((event) {
      typeAndImageList = List.generate(event.docs.length,
          (index) => TypeofWorkModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void _fetchAllPopular() {
    DBHelper.fetchAllPopular().listen((event) {
      popularList = List.generate(event.docs.length,
          (index) => TypeofWorkModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> workerById(String workerId) {
    return DBHelper.workerById(workerId);
  }
}
