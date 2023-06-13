// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? email;
  String? password;
  Auth({required this.email, required this.password});
}
