import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapPage extends StatefulWidget {
  static const String routeName = '/map';

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late WorkerProvider _workerProvider;
  double currentlat = 0.0;
  double currentlon = 0.0;
  String? name;
  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _workerProvider.fetchAllWorkerByType(argList[0]);
    name = argList[0];
    currentlat = argList[1];
    currentlon = argList[2];
    super.didChangeDependencies();
  }

  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: btncolor,
        title: Text("See nearest $name"),
      ),
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: _workerProvider.workerList.length,
              itemBuilder: (context, index) {
                markers.add(Marker(
                    infoWindow: InfoWindow(
                        title: '${_workerProvider.workerList[index].name}'),
                    markerId:
                        MarkerId('${_workerProvider.workerList[index].name}'),
                    position: LatLng(
                      double.parse("${_workerProvider.workerList[index].lat}"),
                      double.parse("${_workerProvider.workerList[index].lon}"),
                    )));
                return SizedBox();
              }),
          Container(
            height: 770.h,
            width: double.infinity,
            child: GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                  target: LatLng(currentlat, currentlon), zoom: 14),
              markers: markers,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
