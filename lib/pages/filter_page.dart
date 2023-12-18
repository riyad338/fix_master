import 'package:fix_masters/pages/Filtered_result_page.dart';
import 'package:fix_masters/pages/show_worker_page.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../utils/helper_function.dart';

class DropDownPage extends StatefulWidget {
  static const String routeName = '/drop';

  const DropDownPage({Key? key}) : super(key: key);

  @override
  State<DropDownPage> createState() => _DropDownPageState();
}

class _DropDownPageState extends State<DropDownPage> {
  String? _name;
  String? _location;

  @override
  late WorkerProvider _workerProvider;
  @override
  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    _workerProvider.init();

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: btncolor,
        title: Text("Filter Search"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              menuMaxHeight: 200.h,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              hint: Text(
                'Worker Type',
              ),
              value: _name,
              onChanged: (value) {
                setState(() {
                  _name = value;

                  _location = null;
                });
              },
              items: _workerProvider.typeAndImageList
                  .map((e) => e.name)
                  .map((locat) => DropdownMenuItem(
                        child: Text(
                          locat!,
                          // style: TextStyle(
                          //     color: themeProvider.themeModeType ==
                          //             ThemeModeType.Dark
                          //         ? Colors.black54
                          //         : Colors.black54),
                        ),
                        value: locat,
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Search By Location';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            DropdownButtonFormField<String>(
              menuMaxHeight: 200.h,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              hint: Text(
                'Location',
              ),
              value: _location,
              onChanged: (value) {
                setState(() {
                  _location = value;
                });
              },
              items: _workerProvider.locationList
                  .map((locat) => DropdownMenuItem(
                        child: Text(
                          locat,
                          // style: TextStyle(
                          //     color: themeProvider.themeModeType ==
                          //             ThemeModeType.Dark
                          //         ? Colors.black54
                          //         : Colors.black54),
                        ),
                        value: locat,
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Search By Location';
                }
                return null;
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_name == null) {
                    showToastMsg("Worker type is empty");
                  } else if (_location == null) {
                    showToastMsg("Location is empty");
                  } else
                    Navigator.pushNamed(context, FilteredResultPage.routeName,
                        arguments: [_name, _location]);
                },
                child: Text("Search"))
          ],
        ),
      ),
    );
  }
}
