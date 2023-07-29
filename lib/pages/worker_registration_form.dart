import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/customwidgets/drawer.dart';
import 'package:fix_masters/models/user_model.dart';
import 'package:fix_masters/models/worker_form_model.dart';
import 'package:fix_masters/pages/login_page.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/user_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../utils/helper_function.dart';

class WorkerRegPage extends StatefulWidget {
  static const String routeName = '/workreg';

  @override
  _WorkerRegPageState createState() => _WorkerRegPageState();
}

class _WorkerRegPageState extends State<WorkerRegPage> {
  late WorkerProvider _workerProvider;
  final _formKey = GlobalKey<FormState>();
  String? _workLocation;
  String? _workType;
  DateTime? _dateTime;
  bool isLoading = false;
  WorkerFormModel _workerFormModel =
      WorkerFormModel(date: Timestamp.fromDate(DateTime.now()));
  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  @override
  _getPosition() async {
    await determinePosition().then((position) {
      setState(() {
        _workerFormModel.lat = position.latitude;
        _workerFormModel.lon = position.longitude;
      });
    });
  }

  bool _isInit = true;
  void didChangeDependencies() {
    if (_isInit) {
      _getPosition();
      _workerProvider = Provider.of<WorkerProvider>(context);
      _workerProvider.init();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.5,
      progressIndicator: spinkit,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: themeProvider.themeModeType == ThemeModeType.Dark
                      ? Colors.white
                      : Colors.black,
                )),
          ),
          title: const Text('Add to Worker'),
          actions: [
            IconButton(
                onPressed: () {
                  AuthService.logout().then((_) =>
                      Navigator.pushReplacementNamed(
                          context, LoginPage.routeName));
                  showToastMsg("Logout Successfully");
                },
                icon: Icon(Icons.logout))
          ],
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
                        _workerFormModel.name = value;
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
                  Card(
                    elevation: 5,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      //maxLines: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return emptyFieldErrMsg;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _workerFormModel.phone = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5,
                    child: TextFormField(
                      //maxLines: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return emptyFieldErrMsg;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _workerFormModel.description = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Card(
                    elevation: 5,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('Location'),
                      value: _workLocation,
                      onChanged: (value) {
                        setState(() {
                          _workLocation = value;
                        });
                      },
                      onSaved: (value) {
                        _workerFormModel.location = value;
                      },
                      items: _workerProvider.locationList
                          .map((cat) => DropdownMenuItem(
                                child: Text(cat),
                                value: cat,
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Location';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Card(
                    elevation: 5,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: Text('Work Type'),
                      value: _workType,
                      onChanged: (value) {
                        setState(() {
                          _workType = value;
                        });
                      },
                      onSaved: (value) {
                        _workerFormModel.type = value;
                      },
                      items: _workerProvider.workTypeList
                          .map((cat) => DropdownMenuItem(
                                child: Text(cat),
                                value: cat,
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a work type';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: btncolor),
                            onPressed: _showDatePicker,
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.black,
                            ),
                            label: Text(
                              'Select Date',
                              style: TextStyle(color: Colors.black),
                            )),
                        Text(_dateTime == null
                            ? 'No date chosen'
                            : getFormattedDate(_dateTime!, 'MMM dd, yyyy')),
                      ],
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
                            _saveWorkerDetails();
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

  void _saveWorkerDetails() async {
    final isConnected = await isConnectedToInternet();
    if (isConnected) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (_dateTime == null) {
          showToastMsg('Please a select a date');
          return;
        }
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

  void _showDatePicker() async {
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (dt != null) {
      setState(() {
        _dateTime = dt;
        _workerFormModel.date = Timestamp.fromDate(_dateTime!);
      });
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
        '${_workerFormModel.name}_${DateTime.now().microsecondsSinceEpoch}';
    _workerFormModel.imageName = imageName;

    final photoref =
        FirebaseStorage.instance.ref().child('$photoDirectory/$imageName');
    final uploadtask = photoref.putFile(File(_imagePath!));
    final snapshot = await uploadtask.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();
    _workerFormModel.imageDownloadUrl = downloadurl;

    _workerProvider.insertNewWorker(_workerFormModel).then((value) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Save your response")));
    }).catchError((error) {
      showToastMsg('Could not save');
    });
  }
}
