import 'package:fix_masters/pages/user_profile_and_update.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/user_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_service.dart';
import '../pages/login_page.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late UserProvider _userProvider;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? userImage;
  String? userName;
  String? userEmail;
  String? userPhone;

  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _userProvider = Provider.of<UserProvider>(context);
      _userProvider.getCurrentUser(AuthService.currentUser!.uid).then((user) {
        if (user != null) {
          userImage = user.picture;
          userName = user.name;
          userEmail = user.email;
          userPhone = user.phone;
          setState(() {});
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> share() async {
      await FlutterShare.share(
          title: 'Fix Master',
          linkUrl:
              'https://drive.google.com/drive/u/0/folders/19PK88ujl0v1B1iDwY2nnRHH3_Aw_5Rfk',
          chooserTitle: 'Example Chooser Title');
    }

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: Column(children: [
        Container(
          color: btncolor,
          height: 270.h,
          child: Padding(
            padding: EdgeInsets.only(left: 10.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.r,
                    backgroundImage:
                        NetworkImage(userImage == null ? "" : userImage!),
                  ),
                ),
                ListTile(
                  title: Text(userName == null ? "" : userName!),
                ),
                ListTile(
                  title: Text(userEmail == null ? "" : userEmail!),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, UserProfileandUpdatePage.routeName);
          },
          leading: Icon(Icons.person),
          title: Text('My Profile'),
        ),
        ListTile(
          onTap: () async {
            share();
          },
          leading: Icon(Icons.share),
          title: Text('Share'),
        ),
        ListTile(
          onTap: () async {
            setState(() {
              themeProvider.toggleTheme();
            });
          },
          trailing: Switch(
            value: themeProvider.themeModeType == ThemeModeType.Dark,
            onChanged: (value) {
              setState(() {
                themeProvider.toggleTheme();
              });
            },
          ),
          leading: Icon(Icons.dark_mode),
          title: Text('Dark Mood'),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(Icons.warning),
          title: Text('Terms & Conditions'),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(Icons.verified_user),
          title: Text('Privacy Policy'),
        ),
        ListTile(
          onTap: () async {
            showToastMsg("Logout Successfully");
            await _googleSignIn.signOut().then((_) =>
                Navigator.pushReplacementNamed(context, LoginPage.routeName));
            await AuthService.logout().then((_) =>
                Navigator.pushReplacementNamed(context, LoginPage.routeName));
          },
          leading: Icon(Icons.logout),
          title: Text('Logout'),
        ),
        Container(
          width: double.infinity,
          height: 1.h,
          color: Colors.grey,
        ),
        ListTile(
          onTap: () {},
          leading: Icon(Icons.info),
          title: Text('About'),
          subtitle: Text("Version 1.0.1"),
        ),
      ]),
    );
  }
}
