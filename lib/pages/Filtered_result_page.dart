import 'package:fix_masters/customwidgets/worker_searchby_location.dart';
import 'package:fix_masters/customwidgets/workers.dart';
import 'package:fix_masters/pages/google_map.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class FilteredResultPage extends StatefulWidget {
  static const String routeName = '/filter_result';

  @override
  State<FilteredResultPage> createState() => _FilteredResultPageState();
}

class _FilteredResultPageState extends State<FilteredResultPage> {
  late WorkerProvider _workerProvider;
  String? name;
  String? _workLocation;

  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _workerProvider.fetchAllWorkerByType(argList[0]);

    name = argList[0];
    _workLocation = argList[1];
    _workerProvider.fetchAllWorkerByTypeAndLocation(name!, _workLocation!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: btncolor,
        title: Text("$name at $_workLocation area"),
        actions: [
          Container(
            width: 65,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0.w),
              child: InkWell(
                onTap: () async {
                  Position position = await determinePosition();
                  Navigator.pushNamed(context, GoogleMapPage.routeName,
                      arguments: [name, position.latitude, position.longitude]);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.black54),
                  child: Icon(
                    Icons.map,
                    size: 30.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // sliver app bar
          // SliverAppBar(
          //   automaticallyImplyLeading: false,
          //   expandedHeight: 50.h,
          //   backgroundColor: btncolor,
          //
          //   floating: true,
          //
          //   title: Padding(
          //     padding: EdgeInsets.only(left: 10.0.w),
          //     child: Row(
          //       children: [
          //         Card(
          //           elevation: 0,
          //           child: Container(
          //             width: 300.w,
          //             child: DropdownButtonFormField<String>(
          //               menuMaxHeight: 200.h,
          //               decoration: InputDecoration(
          //                 contentPadding: EdgeInsets.symmetric(
          //                     vertical: 10.h, horizontal: 10.w),
          //                 border: OutlineInputBorder(
          //                     borderSide: BorderSide(color: Colors.white)),
          //               ),
          //               hint: Text(
          //                 'Search By Location',
          //               ),
          //               value: _workLocation,
          //               onChanged: (value) {
          //                 setState(() {
          //                   _workLocation = value;
          //                 });
          //               },
          //               items: _workerProvider.locationList
          //                   .map((locat) => DropdownMenuItem(
          //                         child: Text(
          //                           locat,
          //                           // style: TextStyle(
          //                           //     color: themeProvider.themeModeType ==
          //                           //             ThemeModeType.Dark
          //                           //         ? Colors.black54
          //                           //         : Colors.black54),
          //                         ),
          //                         value: locat,
          //                       ))
          //                   .toList(),
          //               validator: (value) {
          //                 if (value == null || value.isEmpty) {
          //                   return 'Search By Location';
          //                 }
          //                 return null;
          //               },
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(left: 8.0.w),
          //           child: InkWell(
          //             onTap: () async {
          //               Position position = await determinePosition();
          //               Navigator.pushNamed(context, GoogleMapPage.routeName,
          //                   arguments: [
          //                     name,
          //                     position.latitude,
          //                     position.longitude
          //                   ]);
          //             },
          //             child: Container(
          //               height: 45.h,
          //               width: 50.w,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(15.r),
          //                   color: Colors.black54),
          //               child: Icon(
          //                 Icons.map,
          //                 size: 30.sp,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          //   // flexibleSpace: FlexibleSpaceBar(
          //   //   title: Text('F A N C Y A P P B A R'),
          //   //   background: Container(color: Colors.deepPurple[700]),
          //   // ),
          // ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: _workLocation == null
                  ? _workerProvider.workerList.isEmpty
                      ? Center(child: Text("No $name available"))
                      : GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio: 1,
                          children: _workerProvider.workerList
                              .map((e) => Workers(e))
                              .toList(),
                        )
                  : _workerProvider.workerLocationList.isEmpty
                      ? Center(child: Text("No $name available"))
                      : GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio: 1,
                          children: _workerProvider.workerLocationList
                              .map((e) => WorkerSearchByLocation(e))
                              .toList(),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
