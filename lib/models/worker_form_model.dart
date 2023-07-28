import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerFormModel {
  String? id;
  String? name;
  String? phone;
  String? type;
  double? lat;
  double? lon;
  String? location;
  String? imageName;
  String? imageDownloadUrl;
  String? description;
  Timestamp? date;
  bool isAvailable;

  WorkerFormModel(
      {this.id,
      this.name,
      this.phone,
      this.type,
      this.lat,
      this.lon,
      this.location,
      this.imageDownloadUrl,
      required this.date,
      this.description,
      this.isAvailable = true,
      this.imageName});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'type': type,
      'lat': lat,
      'lon': lon,
      'location': location,
      'imageDownloadUrl': imageDownloadUrl,
      'description': description,
      'date': date,
      'isAvailable': isAvailable,
      'imageName': imageName,
    };
    return map;
  }

  factory WorkerFormModel.fromMap(Map<String, dynamic> map) => WorkerFormModel(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        type: map['type'],
        lat: map['lat'],
        lon: map['lon'],
        location: map['location'],
        imageDownloadUrl: map['imageDownloadUrl'],
        description: map['description'],
        date: map['date'],
        isAvailable: map['isAvailable'],
        imageName: map['imageName'],
      );

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name,phone:$phone, category: $type, lat: $lat,lon:$lon,location:$location,imageName: $imageName, imageDownloadUrl: $imageDownloadUrl, description: $description, date:$date,isAvailable: $isAvailable,}';
  }
}
