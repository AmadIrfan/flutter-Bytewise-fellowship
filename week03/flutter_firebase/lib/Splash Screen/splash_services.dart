import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_firebase/Auth/login_page.dart';
import 'package:flutter_firebase/fire_store_home.dart';
import '../windows/home_page.dart';

class SplashServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void isLogin(BuildContext context) {
    Timer(
      const Duration(seconds: 04),
      () {
        User? user = _firebaseAuth.currentUser;
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const HomePage(),
        //   ),
        // );
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FirebaseFireStoreHome(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      },
    );
  }
}
