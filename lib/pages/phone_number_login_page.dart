import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/db/db_helper.dart';
import 'package:fix_masters/models/user_model.dart';
import 'package:fix_masters/pages/home_page.dart';
import 'package:fix_masters/pages/worker_or_user_page.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/user_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PhoneAuthPage extends StatefulWidget {
  static const String routeName = '/phone_login';
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  int start = 30;
  bool wait = false;
  bool isLogin = true;
  String buttonName = "Send";
  TextEditingController phoneController = TextEditingController();
  AuthService authClass = AuthService();
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: themeProvider.themeModeType == ThemeModeType.Dark
                  ? Colors.white
                  : Colors.black,
            )),
        backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
            ? Colors.black54
            : Colors.white,
        title: Text(
          "SignUp With Phone",
          style: TextStyle(
              color: themeProvider.themeModeType == ThemeModeType.Dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "images/logoname.png",
                height: 150.h,
                width: 150.w,
                fit: BoxFit.fill,
              ),
              textField(themeProvider),
              SizedBox(
                height: 30.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.h,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                      ),
                    ),
                    Text(
                      "Enter 6 digit OTP",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color:
                              themeProvider.themeModeType == ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black),
                    ),
                    Expanded(
                      child: Container(
                        height: 1.h,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              otpField(themeProvider),
              SizedBox(
                height: 40.h,
              ),
              RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: "Send OTP again in ",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: themeProvider.themeModeType == ThemeModeType.Dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "00:$start",
                    style: TextStyle(fontSize: 16.sp, color: Colors.pinkAccent),
                  ),
                  TextSpan(
                    text: " sec ",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: themeProvider.themeModeType == ThemeModeType.Dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              )),
              SizedBox(
                height: 150.h,
              ),
              InkWell(
                onTap: () {
                  signInwithPhoneNumber(verificationIdFinal, smsCode, context);
                },
                child: Container(
                  height: 60.h,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                      color: btncolor,
                      borderRadius: BorderRadius.circular(15.r)),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          fontSize: 17.sp,
                          color:
                              themeProvider.themeModeType == ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField(ThemeProvider themeProvider) {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 58.w,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
            ? Colors.black54
            : Colors.black26,
        borderColor: Colors.white,
      ),
      style: TextStyle(fontSize: 17.sp, color: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textField(ThemeProvider themeProvider) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60.h,
      decoration: BoxDecoration(
        color: themeProvider.themeModeType == ThemeModeType.Dark
            ? Colors.black54
            : Colors.black26,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TextFormField(
        controller: phoneController,
        style: TextStyle(color: Colors.white, fontSize: 17.sp),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your phone Number",
          hintStyle: TextStyle(color: Colors.white54, fontSize: 17.sp),
          contentPadding: EdgeInsets.symmetric(vertical: 19.h, horizontal: 8.w),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
            child: Text(
              " (+880) ",
              style: TextStyle(color: Colors.white, fontSize: 17.sp),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait
                ? null
                : () async {
                    setState(() {
                      start = 30;
                      wait = true;
                      buttonName = "Resend";
                    });
                    await verifyPhoneNumber(
                        "+880 ${phoneController.text}", context, setData);
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
              child: Text(
                buttonName,
                style: TextStyle(
                  color: wait ? Colors.grey : Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent = (String verificationID, [forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await _auth.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        bool isFirstTimeSignIn = await DBHelper.isUserExists(user.uid);

        if (!isFirstTimeSignIn) {
          // Add the user's data to the database using UserModel.
          UserModel userModel = UserModel(
            userId: user.uid,
            phone: user.phoneNumber,
            userCreationTime:
                user.metadata.creationTime!.millisecondsSinceEpoch,
          );

          // Save user data in your user collection
          Provider.of<UserProvider>(context, listen: false).addUser(userModel);
          Navigator.pushReplacementNamed(context, WorkerOrUser.routeName);
        }

        // Proceed to the main screen or any other screen.
        AuthService.roleBaseLogin(context);
      }

      showSnackBar(context, "logged In");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
