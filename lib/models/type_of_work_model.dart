import 'package:cloud_firestore/cloud_firestore.dart';

class TypeofWorkModel {
  String? id;
  String? name;
  String? imageName;
  String? imageDownloadUrl;

  TypeofWorkModel({this.id, this.name, this.imageDownloadUrl, this.imageName});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'imageDownloadUrl': imageDownloadUrl,
      'imageName': imageName,
    };
    return map;
  }

  factory TypeofWorkModel.fromMap(Map<String, dynamic> map) => TypeofWorkModel(
        id: map['id'],
        name: map['name'],
        imageDownloadUrl: map['imageDownloadUrl'],
        imageName: map['imageName'],
      );

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name,imageName: $imageName, imageDownloadUrl: $imageDownloadUrl, }';
  }
}
