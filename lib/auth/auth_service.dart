import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_masters/admin/dashboard.dart';
import 'package:fix_masters/pages/home_page.dart';
import 'package:fix_masters/pages/worker_registration_form.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;
  final storage = new FlutterSecureStorage();
  static Future<User?> loginUser(String email, String pass) async {
    final credential =
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return credential.user;
  }

  static Future<User?> registerUser(String email, String pass) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);
    return credential.user;
  }

  static Future<void> roleBaseLogin(context) async {
    if (_auth.currentUser != null) {
      var userType = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser?.uid)
          .get();

      if (userType['role'] == 'User') {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } else if (userType['role'] == 'Worker') {
        Navigator.pushReplacementNamed(context, WorkerRegPage.routeName);
      } else if (userType['role'] == 'admin') {
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
    }
  }

  static bool isUserVerified() => _auth.currentUser?.emailVerified ?? false;

  static Future<void> sendVerificationMail() {
    return _auth.currentUser!.sendEmailVerification();
  }

  static Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
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

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);

      showSnackBar(context, "logged In");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  static Future<void> logout() {
    return _auth.signOut();
  }
}
