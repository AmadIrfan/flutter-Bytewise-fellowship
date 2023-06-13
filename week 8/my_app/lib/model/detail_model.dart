import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Details with ChangeNotifier {
  String? id;
  String? name;
  String? description;
  String? imageUrl;
  String? email;
  List<String?>? skills;

  Details(
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.email,
    this.skills,
  );
}

class DetailsData with ChangeNotifier {
  Future<Map<String, dynamic>?> getUserData(String id) async {
    final fStore = FirebaseFirestore.instance;
    final data = await fStore.collection('users').doc(id).get();
    return data.data();
  }
}
