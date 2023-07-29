import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_masters/admin/dashboard.dart';
import 'package:fix_masters/models/user_model.dart';
import 'package:fix_masters/pages/home_page.dart';
import 'package:fix_masters/pages/worker_or_user_page.dart';
import 'package:fix_masters/pages/worker_registration_form.dart';
import 'package:fix_masters/providers/user_provider.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthService {
  late UserModel usermodel;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

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
      } else if (userType['role'] == null) {
        Navigator.pushReplacementNamed(context, WorkerOrUser.routeName);
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

  static Future<void> logout() {
    return _auth.signOut();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final storage = new FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        User? user = userCredential.user;
        UserModel userModel = UserModel(
          userId: user!.uid,
          email: user.email!,
          userCreationTime: user.metadata.creationTime!.millisecondsSinceEpoch,
        );

        // Save user data in your user collection
        Provider.of<UserProvider>(context, listen: false).addUser(userModel);

        Navigator.pushReplacementNamed(context, WorkerOrUser.routeName);
      } else {
        AuthService.roleBaseLogin(context);
        showToastMsg("Login Successfully");
      }
      // if (googleSignInAccount != null) {
      //   storeTokenAndData(userCredential);
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (builder) => HomePage()),
      //       (route) => false);
      // }
    } catch (e) {
      print("here---->");
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }
}
