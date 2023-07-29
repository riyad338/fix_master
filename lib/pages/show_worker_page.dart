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

class ShowWorkerPage extends StatefulWidget {
  static const String routeName = '/show_workerpage';

  @override
  State<ShowWorkerPage> createState() => _ShowWorkerPageState();
}

class _ShowWorkerPageState extends State<ShowWorkerPage> {
  late WorkerProvider _workerProvider;
  String? name;
  String? _workLocation;

  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _workerProvider.fetchAllWorkerByType(argList[0]);

    name = argList[0];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: btncolor,
        title: Text("All $name"),
      ),
      body: CustomScrollView(
        slivers: [
          // sliver app bar
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 50,
            backgroundColor: btncolor,

            floating: true,

            title: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Card(
                    elevation: 0,
                    child: Container(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                        hint: Text(
                          'Search By Location',
                        ),
                        value: _workLocation,
                        onChanged: (value) {
                          setState(() {
                            _workLocation = value;
                            _workerProvider.fetchAllWorkerByTypeAndLocation(
                                name!, value!);
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
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: InkWell(
                      onTap: () async {
                        Position position = await determinePosition();
                        Navigator.pushNamed(context, GoogleMapPage.routeName,
                            arguments: [
                              name,
                              position.latitude,
                              position.longitude
                            ]);
                      },
                      child: Container(
                        height: 45.h,
                        width: 50.w,
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
                  )
                ],
              ),
            ),
            // flexibleSpace: FlexibleSpaceBar(
            //   title: Text('F A N C Y A P P B A R'),
            //   background: Container(color: Colors.deepPurple[700]),
            // ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 10,
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 10.0),
      //         child: Row(
      //           children: [
      //             Card(
      //               elevation: 5,
      //               child: Container(
      //                 width: 300,
      //                 child: DropdownButtonFormField<String>(
      //                   decoration: InputDecoration(
      //                     contentPadding: EdgeInsets.symmetric(
      //                         vertical: 10, horizontal: 10),
      //                     border: OutlineInputBorder(),
      //                   ),
      //                   hint: Text('Search By Location'),
      //                   value: _workLocation,
      //                   onChanged: (value) {
      //                     setState(() {
      //                       _workLocation = value;
      //                       _workerProvider.fetchAllWorkerByTypeAndLocation(
      //                           name!, value!);
      //                     });
      //                   },
      //                   items: _workerProvider.locationList
      //                       .map((locat) => DropdownMenuItem(
      //                             child: Text(locat),
      //                             value: locat,
      //                           ))
      //                       .toList(),
      //                   validator: (value) {
      //                     if (value == null || value.isEmpty) {
      //                       return 'Search By Location';
      //                     }
      //                     return null;
      //                   },
      //                 ),
      //               ),
      //             ),
      //             Padding(
      //               padding: EdgeInsets.only(left: 8.0.w),
      //               child: InkWell(
      //                 onTap: () async {
      //                   Position position = await determinePosition();
      //                   Navigator.pushNamed(context, GoogleMapPage.routeName,
      //                       arguments: [
      //                         name,
      //                         position.latitude,
      //                         position.longitude
      //                       ]);
      //                 },
      //                 child: Container(
      //                   height: 55.h,
      //                   width: 65.w,
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(15.r),
      //                       color: btncolor),
      //                   child: Icon(
      //                     Icons.map,
      //                     size: 30.sp,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //       _workLocation == null
      //           ? _workerProvider.workerList.isEmpty
      //               ? Text("No $name available")
      //               : GridView.count(
      //                   physics: NeverScrollableScrollPhysics(),
      //                   shrinkWrap: true,
      //                   crossAxisCount: 2,
      //                   mainAxisSpacing: 2,
      //                   crossAxisSpacing: 2,
      //                   childAspectRatio: 1,
      //                   children: _workerProvider.workerList
      //                       .map((e) => Workers(e))
      //                       .toList(),
      //                 )
      //           : _workerProvider.workerLocationList.isEmpty
      //               ? Text("No $name available")
      //               : GridView.count(
      //                   shrinkWrap: true,
      //                   crossAxisCount: 2,
      //                   mainAxisSpacing: 2,
      //                   crossAxisSpacing: 2,
      //                   childAspectRatio: 1,
      //                   children: _workerProvider.workerLocationList
      //                       .map((e) => WorkerSearchByLocation(e))
      //                       .toList(),
      //                 ),
      //     ],
      //   ),
      // ),
    );
  }
}
