// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_instagram/model_view/model/Auth.dart';
import 'package:flutter_instagram/res/component/show_message.dart';

import '../../view/home_page.dart';
import 'iuser.dart';

class AuthMethods with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logIn(Auth auth, BuildContext context) async {
    // return ;
    try {
      await _auth.signInWithEmailAndPassword(
        email: auth.email.toString(),
        password: auth.password.toString(),
      );
      Utils(message: "login Successfully", color: Colors.green).showMessage();
      // print(_auth.currentUser!.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils(message: 'No user found for that email.', color: Colors.red)
            .showMessage();
      } else if (e.code == 'wrong-password') {
        Utils(
                message: 'Wrong password provided for that user.',
                color: Colors.red)
            .showMessage();
      }
    } catch (e) {
      Utils(message: e.toString(), color: Colors.red).showMessage();
    }

    notifyListeners();
  }

  void signUp(Auth auth, IUser u) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
        email: auth.email.toString(),
        password: auth.password.toString(),
      );
      String id = uc.user!.uid;
      IUser uesr = IUser(
        userId: id,
        userName: u.userName,
        bio: u.bio,
        followers: u.followers,
        following: u.following,
        imageUrl: u.imageUrl,
      );
      await _firestore.collection('users').doc(id).set(
            uesr.toJson(),
          );
      Utils(message: 'Reister Successfully', color: Colors.green).showMessage();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils(message: 'The password provided is too weak', color: Colors.red)
            .showMessage();
      } else if (e.code == 'email-already-in-use') {
        Utils(
          message: 'The account already exists for that email.',
          color: Colors.red,
        ).showMessage();
      }
    } catch (e) {
      Utils(message: e.toString(), color: Colors.red).showMessage();
    }

    notifyListeners();
  }

  Future<IUser> getUserData() async {
    User? user = _auth.currentUser;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(user!.uid).get();
    return IUser.fromSnap(snap);
  }
}
