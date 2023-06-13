import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  final String message;
  final Color? color;

  Utils({
    required this.message,
    this.color = Colors.red,
  });

  void showMessage() {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16,
      timeInSecForIosWeb: 2,
    );
  }
}
