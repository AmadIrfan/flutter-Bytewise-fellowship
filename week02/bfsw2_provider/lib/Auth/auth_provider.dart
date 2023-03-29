import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  void login(String email, String password) async {
    try {
      Uri url = Uri.parse('https://reqres.in/api/login');
      http.Response response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Successful');
        }
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print('password missing');
        }
      } else {
        if (kDebugMode) {
          print('failed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          e.toString(),
        );
      }
    }
  }
}
