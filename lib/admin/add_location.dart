import 'package:fix_masters/models/location_model.dart';
import 'package:fix_masters/providers/admin_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddNewLocationPage extends StatefulWidget {
  static const String routeName = '/location_add';

  @override
  State<AddNewLocationPage> createState() => _AddNewLocationPageState();
}

class _AddNewLocationPageState extends State<AddNewLocationPage> {
  TextEditingController _locationController = TextEditingController();
  late AdminProvider _adminProvider;
  late WorkerProvider _workerProvider;

  void didChangeDependencies() {
    _adminProvider = Provider.of<AdminProvider>(context);
    _workerProvider = Provider.of<WorkerProvider>(context);
    _workerProvider.init();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Categories"),
      ),
      body: ListView.builder(
          itemCount: _workerProvider.locationList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text("${_workerProvider.locationList[index]}"),
                trailing: IconButton(
                  onPressed: () {
                    _adminProvider.deleteLocation(
                        "${_workerProvider.locationList[index]}");
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          onPressed: () {
            _showDialog(context);
          },
          child: Icon(Icons.add)),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 20,
          title: Text("Add new location"),
          content: TextFormField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.edit),
              hintText: "Add location",
            ),
            controller: _locationController,
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 20.w,
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                setState(() {
                  _addNewCategorie();
                });
              },
            ),
          ],
        );
      },
    );
  }

  _addNewCategorie() {
    _adminProvider.addLocation(
        _locationController.text, _locationController.text);
    Navigator.pop(context);
    _locationController.clear();
  }
}
