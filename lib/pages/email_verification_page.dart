import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String routeName = '/email_verification';

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    AuthService.sendVerificationMail();
    // FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = AuthService.isUserVerified();
      // FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));

      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 35.h),
          SizedBox(height: 30.h),
          Center(
            child: Text(
              'Check your \n Email',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(
              child: Text(
                'We have sent you a Email on  ${FirebaseAuth.instance.currentUser?.email}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const Center(
              child: CircularProgressIndicator(
            color: Colors.greenAccent,
          )),
          SizedBox(height: 8.h),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(
              child: Text(
                'Verifying email....',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 57.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              child: const Text('Resend'),
              onPressed: () {
                try {
                  AuthService.sendVerificationMail();
                } catch (e) {
                  debugPrint('$e');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
