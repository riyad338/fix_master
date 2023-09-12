import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/pages/home_page.dart';
import 'package:fix_masters/pages/worker_registration_form.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WorkerOrUser extends StatefulWidget {
  static const String routeName = '/workeroruser';

  @override
  State<WorkerOrUser> createState() => _WorkerOrUserState();
}

class _WorkerOrUserState extends State<WorkerOrUser> {
  late WorkerProvider _workerProvider;
  @override
  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    _workerProvider.init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "images/logoname.png",
              height: 250.h,
              width: 300.w,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 30.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
                backgroundColor: btncolor,
              ),
              onPressed: () async {
                await _workerProvider.insertRole(
                    AuthService.currentUser!.uid, "User");
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              },
              child: Text("Hiring?"),
            ),
            SizedBox(
              height: 30.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
                backgroundColor: btncolor,
              ),
              onPressed: () async {
                await _workerProvider.insertRole(
                    AuthService.currentUser!.uid, "Worker");
                Navigator.pushReplacementNamed(
                    context, WorkerRegPage.routeName);
              },
              child: Text("Worker?"),
            ),
          ],
        ),
      ),
    );
  }
}
