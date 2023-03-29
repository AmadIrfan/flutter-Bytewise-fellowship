// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  int? id;
  String? name;
  String? description;
  double? price;

  Product(int id, String this.name, String this.description, double price) {
    this.id = id;
    this.price = price;
  }
}

class ProductItem with ChangeNotifier {
  final List<Product> _item = [];
  List<Product> get item => _item;

  addItemInList(Product product) {
    _item.insert(0, product);
    notifyListeners();
  }

  updateItem(int id, Product product) {
    if (id >= 0) {
      _item.insert(id, product);
    }
    notifyListeners();
  }

  deleteItem(int id) {
    if (id >= 0) {
      _item.removeWhere(
        ((element) => element.id == id),
      );
    }
    notifyListeners();
  }

  int get listLength {
    return _item.length;
  }

  double get totalPrice {
    double sum = 0.0;
    sum = _item.fold(
        0.0, (previousValue, element) => previousValue + element.price!);
    return sum;
  }
}
