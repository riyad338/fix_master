import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  String? id;
  String? name;

  LocationModel({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
    };
    return map;
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) => LocationModel(
        id: map['id'],
        name: map['name'],
      );

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, }';
  }
}
