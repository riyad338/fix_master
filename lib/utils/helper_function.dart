import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

showToastMsg(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<bool> isConnectedToInternet() async {
  final result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

String getFormattedDate(DateTime dateTime, String format) {
  return DateFormat(format).format(dateTime);
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void contactCall(BuildContext context, String mobile) async {
  final url = 'tel:$mobile';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Could not launch application")));
    throw 'Could not launch application';
  }
}

var spinkit = SpinKitFadingCircle(
  color: Colors.greenAccent,
);
