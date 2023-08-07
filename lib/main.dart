import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fix_masters/admin/add_location.dart';
import 'package:fix_masters/admin/add_new_type.dart';
import 'package:fix_masters/admin/dashboard.dart';
import 'package:fix_masters/pages/email_verification_page.dart';
import 'package:fix_masters/pages/google_map.dart';
import 'package:fix_masters/pages/home_page.dart';
import 'package:fix_masters/pages/launcher_page.dart';
import 'package:fix_masters/pages/login_page.dart';
import 'package:fix_masters/pages/phone_number_login_page.dart';
import 'package:fix_masters/pages/show_worker_page.dart';
import 'package:fix_masters/pages/user_profile_and_update.dart';
import 'package:fix_masters/pages/worker_details_page.dart';
import 'package:fix_masters/pages/worker_or_user_page.dart';
import 'package:fix_masters/pages/worker_registration_form.dart';
import 'package:fix_masters/providers/admin_provider.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/user_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  FirebaseMessaging.instance.getInitialMessage();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => WorkerProvider()),
    ChangeNotifierProvider(create: (context) => AdminProvider()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(415, 860),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(),
              child:
                  Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  theme: themeProvider.themeData,
                  // theme: ThemeData(
                  //   appBarTheme: AppBarTheme(color: Colors.blueAccent.shade200),
                  //   textTheme: GoogleFonts.robotoTextTheme(),
                  //   primarySwatch: Colors.blue,
                  // ),
                  home: LauncherPage(),
                  routes: {
                    LauncherPage.routeName: (context) => LauncherPage(),
                    LoginPage.routeName: (context) => LoginPage(),
                    HomePage.routeName: (context) => HomePage(),
                    WorkerOrUser.routeName: (context) => WorkerOrUser(),
                    WorkerRegPage.routeName: (context) => WorkerRegPage(),
                    ShowWorkerPage.routeName: (context) => ShowWorkerPage(),
                    EmailVerificationScreen.routeName: (context) =>
                        EmailVerificationScreen(),
                    GoogleMapPage.routeName: (context) => GoogleMapPage(),
                    WorkerDetailsPage.routeName: (context) =>
                        WorkerDetailsPage(),
                    AddNewTypePage.routeName: (context) => AddNewTypePage(),
                    DashboardPage.routeName: (context) => DashboardPage(),
                    AddNewLocationPage.routeName: (context) =>
                        AddNewLocationPage(),
                    UserProfileandUpdatePage.routeName: (context) =>
                        UserProfileandUpdatePage(),
                    PhoneAuthPage.routeName: (context) => PhoneAuthPage(),
                  },
                );
              }));
        });
  }
}
