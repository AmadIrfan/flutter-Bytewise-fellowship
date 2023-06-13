import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IUser with ChangeNotifier {
  final String? userName;
  final String? userId;
  final String? bio;
  final String? imageUrl;
  final List followers;
  final List following;

  IUser({
    required this.userId,
    required this.userName,
    required this.bio,
    required this.followers,
    required this.following,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "bio": bio,
        "followers": followers,
        "following": following,
        "imageUrl": imageUrl,
      };
  static IUser fromSnap(DocumentSnapshot snap) {
    // print(snap.id);
    final snapShot = snap.data() as Map<String, dynamic>?;
    return IUser(
      userId: snapShot?['userId'],
      userName: snapShot?['userName'],
      bio: snapShot?['bio'],
      followers: snapShot?['followers'] ?? [],
      following: snapShot?['following'] ?? [],
      imageUrl: snapShot?['imageUrl'],
    );
  }
}
