class UserModel {
  String userId;
  String? name;
  String email;
  String? role;
  String? phone;
  String? picture;

  int? userCreationTime;

  UserModel(
      {required this.userId,
      this.name,
      required this.email,
      this.role,
      this.phone,
      this.picture,
      this.userCreationTime});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'picture': picture,
      'userCreationTime': userCreationTime,
    };
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map['userId'],
        name: map['name'],
        email: map['email'],
        role: map['role'],
        phone: map['phone'],
        picture: map['picture'],
        userCreationTime: map['userCreationTime'],
      );
}
