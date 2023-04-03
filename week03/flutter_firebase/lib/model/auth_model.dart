// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Auth/verification_page.dart';
import 'package:flutter_firebase/windows/home_page.dart';
import 'package:flutter_firebase/utils/utils.dart';

class AuthModel with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  void signUp(String email, String password) async {
    try {
      // UserCredential user =
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Utils().resultMessage('successfully SignUp ');
     
    } catch (e) {
      Utils().resultMessage(e.toString());
    }
  }

  void login(String email, String password, BuildContext context) async {
    try {
      // UserCredential user =
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Utils().resultMessage('successfully Login');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      Utils().resultMessage(e.toString());
    }
  }

  void loginWithMobile(String phoneNumber, BuildContext context) async {
    try {
      // UserCredential user =
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (text) {
          Utils().resultMessage(
            text.toString(),
          );
        },
        codeSent: (verificationId, token) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const  VerificationPage()));
        },
        codeAutoRetrievalTimeout: (_) {},
      );
      // Utils().resultMessage('successfully Login');
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      Utils().resultMessage(e.toString());
    }
  }
}
