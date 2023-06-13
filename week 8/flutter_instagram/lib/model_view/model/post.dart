// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel with ChangeNotifier {
  final String? uId;
  final String? pId;
  final String? description;
  final String? timeStemp;
  final String? userName;
  final String? userprofile;
  final String? imagePath;
  final likes;
  PostModel({
    required this.pId,
    required this.uId,
    required this.description,
    required this.likes,
    required this.imagePath,
    required this.timeStemp,
    required this.userName,
    required this.userprofile,
  });

  Map<String, dynamic> toJson() => {
        "uId": uId,
        "pId": pId,
        "description": description,
        "timeStemp": timeStemp,
        "userName": userName,
        "userprofile": userprofile,
        "likes": likes,
        'imagePath': imagePath,
      };

  static PostModel fromJson(DocumentSnapshot snap) {
    final snapShot = snap.data() as Map<String, dynamic>;
    return PostModel(
      pId: snapShot['pId'],
      uId: snapShot['uId'],
      description: snapShot['description'],
      likes: snapShot['likes'],
      timeStemp: snapShot['timeStemp'],
      userName: snapShot['userName'],
      userprofile: snapShot['userprofile'],
      imagePath: snapShot['imagePath'],
    );
  }
}
