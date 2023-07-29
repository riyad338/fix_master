import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fix_masters/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../auth/auth_service.dart';
import 'login_page.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher';
  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (AuthService.currentUser == null) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      } else {
        AuthService.roleBaseLogin(context);
        // Navigator.pushReplacementNamed(context, ProductListPage.routeName);
      }
    });

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        message.notification?.title;
        message.notification?.body;
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification == null) {
        message.notification?.title;
        message.notification?.body;
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        message.notification?.title;
        message.notification?.body;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SpinKitWanderingCubes(
        color: Colors.greenAccent,
      )),
    );
  }
}
