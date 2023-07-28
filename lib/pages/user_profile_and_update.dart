import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/models/user_model.dart';
import 'package:fix_masters/providers/user_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileandUpdatePage extends StatefulWidget {
  static const String routeName = '/user_profile_and_update';

  @override
  State<UserProfileandUpdatePage> createState() => _UserProfileandUpdatePage();
}

class _UserProfileandUpdatePage extends State<UserProfileandUpdatePage> {
  UserModel _userModel = UserModel(
    userId: AuthService.currentUser!.uid,
    email: "",
  );
  bool isSaving = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  late UserProvider _userProvider;

  String? userImage;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _userProvider = Provider.of<UserProvider>(context);
      _userProvider.getCurrentUser(AuthService.currentUser!.uid).then((user) {
        if (user != null) {
          _emailController.text = user.email;
          _nameController.text = user.name!;
          _phoneController.text = user.phone!;
          userImage = user.picture;
          setState(() {});
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: btncolor,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            width: 80.w,
            child: IconButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              onPressed: () {
                _updateUserInformation();
                _uploadImage();
              },
              icon: Text("Save"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: 350.w,
                height: 500.h,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0.r),
                          child: Container(
                            height: 100.h,
                            width: 100.w,
                            child: _imagePath == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    radius: 80.r,
                                    backgroundImage: NetworkImage(
                                        userImage == null ? "" : userImage!),
                                  )
                                : Image.file(
                                    File(_imagePath!),
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 1,
                          child: CircleAvatar(
                              backgroundColor: btncolor,
                              child: IconButton(
                                  onPressed: () {
                                    _updateProfileimage();
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white70,
                                  ))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit),
                        prefixIcon: Icon(Icons.person),
                        hintStyle: TextStyle(color: Colors.black12),
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        filled: true,
                        fillColor: btncolor.withOpacity(0.5),
                      ),
                      controller: _nameController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        suffixIcon: Icon(Icons.lock),
                        enabled: false,
                        hintStyle: TextStyle(color: Colors.black12),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        filled: true,
                        fillColor: btncolor.withOpacity(0.5),
                      ),
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit),
                        prefixIcon: Icon(Icons.call),
                        hintText: "Phone",
                        hintStyle: TextStyle(color: Colors.black12),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        filled: true,
                        fillColor: btncolor.withOpacity(0.5),
                      ),
                      controller: _phoneController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateProfileimage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 20,
          content: Text("Please select"),
          actions: [
            ElevatedButton.icon(
              icon: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade100),
              label: Text(
                'Camera',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _imageSource = ImageSource.camera;
                _pickImage();
              },
            ),
            SizedBox(
              width: 10.w,
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.image,
                color: Colors.black,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade100),
              label: Text(
                'Gallery',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _imageSource = ImageSource.gallery;
                _pickImage();
              },
            ),
          ],
        );
      },
    );
  }

  _updateUserInformation() async {
    final isConnected = await isConnectedToInternet();
    if (isConnected) {
      _userProvider.updateUserProfile(
        AuthService.currentUser!.uid,
        _nameController.text,
        _phoneController.text,
      );
      showToastMsg("Update your profile");
    } else {
      showToastMsg('No internet connection detected.');
    }
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: _imageSource, imageQuality: 60);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        Navigator.pop(context);
      });
    }
  }

  void _uploadImage() async {
    final imageName =
        '${_userModel.email}_${DateTime.now().microsecondsSinceEpoch}';
    final photoref =
        FirebaseStorage.instance.ref().child('UsersPhoto/$imageName');
    final uploadtask = photoref.putFile(File(_imagePath!));
    final snapshot = await uploadtask.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();
    // _userModel.picture = downloadurl;
    _userProvider.updateImage(AuthService.currentUser!.uid, downloadurl);
  }
}
