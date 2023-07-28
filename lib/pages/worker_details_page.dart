import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_masters/models/worker_form_model.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WorkerDetailsPage extends StatefulWidget {
  static const String routeName = '/worker_details';
  @override
  _WorkerDetailsPageState createState() => _WorkerDetailsPageState();
}

class _WorkerDetailsPageState extends State<WorkerDetailsPage> {
  late WorkerProvider _workerProvider;
  String? _workerId;
  String? _workerName;

  @override
  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _workerId = argList[0];
    _workerName = argList[1];
    _workerProvider.workerById(argList[0]);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: btncolor,
        title: Text(
          _workerName!,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Center(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _workerProvider.workerById(_workerId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final worker =
                        WorkerFormModel.fromMap(snapshot.data!.data()!);
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        worker.imageDownloadUrl == null
                            ? CircleAvatar(
                                child: Image.asset(
                                  'images/imagenotavailable.png',
                                  width: double.infinity,
                                  height: 250.h,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: worker.imageDownloadUrl!,
                                height: 150,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    SpinKitFadingCircle(
                                  color: Colors.greenAccent,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                        ListTile(
                          tileColor: Colors.black12,
                          title: Text("${worker.name}"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          onTap: () {
                            contactCall(context, "${worker.phone}");
                          },
                          tileColor: Colors.black12,
                          title: Text("${worker.phone}"),
                          trailing: Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          tileColor: Colors.black12,
                          title: Text("${worker.location}"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          tileColor: Colors.black12,
                          title: Text("${worker.type}"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          ' ${worker.description}',
                        )
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('Failed to fetch data');
                  }
                  return SpinKitThreeBounce(
                    color: Colors.greenAccent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
