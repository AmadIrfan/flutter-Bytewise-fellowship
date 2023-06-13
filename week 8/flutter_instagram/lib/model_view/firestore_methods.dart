// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instagram/model_view/model/iuser.dart';
import 'package:uuid/uuid.dart';

import 'model/post.dart';

class FireStoreMethost with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadPost(String path, File file) async {
    Reference ref = _storage.ref().child(path).child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(file);
    await Future.value(uploadTask);
    // TaskSnapshot sp = await uploadTask;
    // String link = await sp.ref.getDownloadURL();
    String link = await ref.getDownloadURL();

    return link;
  }

  void postPost(IUser? u, String des, String imgPath) async {
    Uuid uid = const Uuid();
    String pId = uid.v1();
    DateTime dt = DateTime.now();

    PostModel pmd = PostModel(
      pId: pId,
      uId: _auth.currentUser!.uid,
      description: des,
      likes: [],
      imagePath: imgPath,
      timeStemp: dt.toIso8601String(),
      userName: u?.userName,
      userprofile: u?.imageUrl,
    );
    await _firebaseFirestore
        .collection('posts')
        .doc(
          pId,
        )
        .set(
          pmd.toJson(),
        );
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove(
            [uid],
          ),
        });
      } else {
        _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion(
            [uid],
          ),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> postComments(
    String postId,
    String comments,
    String uId,
    String userName,
    String uprofile,
  ) async {
    try {
      if (kDebugMode) {
        print('posting');
      }
      if (comments.isNotEmpty) {
        Uuid uid = const Uuid();
        String cmtId = uid.v1();
        DateTime dt = DateTime.now();
        List likes = [];
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('Comments')
            .doc(cmtId)
            .set({
          'dateTime': dt.toIso8601String(),
          'cmtId': cmtId,
          'postId': postId,
          'likes': likes,
          'comments': comments,
          'uId': uId,
          'userName': userName,
          'uprofile': uprofile,
        });
        if (kDebugMode) {
          print('posted');
        }
      }
    } catch (exp) {
      if (kDebugMode) {
        print(exp);
      }
    }
  }

  Future<void> likeComments(
      String postId, String uid, String cId, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('Comments')
            .doc(cId)
            .update({
          'likes': FieldValue.arrayRemove(
            [uid],
          ),
        });
      } else {
        _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('Comments')
            .doc(cId)
            .update({
          'likes': FieldValue.arrayUnion(
            [uid],
          ),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> followUser(String userId, String followerId) async {
    try {
      print('hitted');
      DocumentSnapshot snap =
          await _firebaseFirestore.collection('users').doc(userId).get();
      List following =
          (snap.data() as Map<String, dynamic>)['following'] as List;
      print(following.contains(followerId));
      if (following.contains(followerId)) {
        print('Contained');
        await _firebaseFirestore.collection('users').doc(followerId).update({
          'followers': FieldValue.arrayRemove([userId]),
        });
        //     'followers'
        //  'following'
        await _firebaseFirestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayRemove([followerId]),
        });
      } else {
        await _firebaseFirestore.collection('users').doc(followerId).update({
          'followers': FieldValue.arrayUnion([userId]),
        });
        await _firebaseFirestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayUnion([followerId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
