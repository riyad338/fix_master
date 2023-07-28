import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fix_masters/models/type_of_work_model.dart';
import 'package:fix_masters/providers/admin_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../utils/helper_function.dart';

class AddNewTypePage extends StatefulWidget {
  static const String routeName = '/new_type';

  @override
  _AddNewTypePageState createState() => _AddNewTypePageState();
}

class _AddNewTypePageState extends State<AddNewTypePage> {
  late AdminProvider _adminProvider;
  TypeofWorkModel _typeofWorkModel = TypeofWorkModel();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  @override
  void didChangeDependencies() {
    _adminProvider = Provider.of<AdminProvider>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.5,
      progressIndicator: spinkit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add to New type'),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(12.0),
                children: [
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2)),
                          child: _imagePath == null
                              ? Image.asset(
                                  'images/noimage.jpg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_imagePath!),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: btncolor),
                              child: Text(
                                'Camera',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                _imageSource = ImageSource.camera;
                                _pickImage();
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: btncolor),
                              child: Text(
                                'Gallery',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                _imageSource = ImageSource.gallery;
                                _pickImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return emptyFieldErrMsg;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _typeofWorkModel.name = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: btncolor),
                          onPressed: () {
                            _saveNewType();
                          },
                          child: Text("Add")),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNewType() async {
    final isConnected = await isConnectedToInternet();
    if (isConnected) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (_imagePath == null) {
          showToastMsg('Please a select an image');
          return;
        }
        setState(() {
          isLoading = true;
        });

        _uploadImageAndSaveProduct();
      }
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
      });
    }
  }

  void _uploadImageAndSaveProduct() async {
    final imageName =
        '${_typeofWorkModel.name}_${DateTime.now().microsecondsSinceEpoch}';
    _typeofWorkModel.imageName = imageName;

    final photoref =
        FirebaseStorage.instance.ref().child('$typephotoDirectory/$imageName');
    final uploadtask = photoref.putFile(File(_imagePath!));
    final snapshot = await uploadtask.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();
    _typeofWorkModel.imageDownloadUrl = downloadurl;
    _adminProvider.addTypeandImage(_typeofWorkModel).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Save your response")));
    }).catchError((error) {
      showToastMsg('Could not save');
    });
  }
}
