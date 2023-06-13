import 'package:flutter/material.dart';

class Posts {
  String? userId;
  String? postId;
  String? title;
  String? body;
  DateTime? dateTime;
  DateTime? updatedTime;
  String? imagePost;
  Posts({
    required this.body,
    required this.postId,
    required this.userId,
    required this.imagePost,
    required this.title,
    required this.dateTime,
    required this.updatedTime,
  });
}

class PostData with ChangeNotifier {
  final List<Posts> _items = [];
  List<Posts> get items {
    return _items;
  }

  void addTOList(Posts p) {
    _items.insert(0, p);
    notifyListeners();
  }
}
